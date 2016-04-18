import beads.*;

AudioContext ac;
PeakDetector od;
float audioPeak = 0.0;
int audioPeakTime = millis();

SamplePlayer splayer;

static final float AUDIO_PEAK_DECREASE_SPEED = 1;

void playMusic(String file) {
  if (ac != null) {
    splayer.start(0);
    return;
  }
  ac = new AudioContext();
  
  //String audioFileName = new File(file).getAbsolutePath();
  Sample sample = SampleManager.sample(file);
  splayer = new SamplePlayer(ac, sample);
  splayer.setKillOnEnd(false);
  splayer.setLoopStart(new Static(ac, 0));
  splayer.setLoopEnd(new Static(ac, (float)sample.getLength()));
  splayer.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  Gain g = new Gain(ac, 2, 0.2);
  g.addInput(splayer);
  ac.out.addInput(g);
  
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.setChunkSize(2048);
  sfs.setHopSize(441);
  sfs.addInput(ac.out);
  FFT fft = new FFT();
  PowerSpectrum ps = new PowerSpectrum();
  sfs.addListener(fft);
  fft.addListener(ps);
  
  /*
   * Given the power spectrum we can now detect changes in spectral energy.
   */
  SpectralDifference sd = new SpectralDifference(ac.getSampleRate());
  ps.addListener(sd);
  od = new PeakDetector();
  sd.addListener(od);
  /*
   * These parameters will need to be adjusted based on the 
   * type of music. This demo uses the mouse position to adjust 
   * them dynamically.
   * mouse.x controls Threshold, mouse.y controls Alpha
   */
  od.setThreshold(0.2f);
  od.setAlpha(.3f);
  
  /*
   * OnsetDetector sends messages whenever it detects an onset.
   */
  od.addMessageListener(
    new Bead(){
      protected void messageReceived(Bead b)
      {
        audioPeak = 1.0;
        audioPeakTime = millis();
      }
    }
  );
  
  ac.out.addDependent(sfs);
  
  ac.start();
}

void getAudioNoise(float[] out) {
  if (null == ac) return;
  int bsz = ac.getBufferSize();
  for (int i = 0; i < out.length && i < bsz; ++i)
    out[i] = ac.out.getValue(0, i);
}

float getAudioPeak() {
  int t = millis();
  float p = audioPeak - AUDIO_PEAK_DECREASE_SPEED * .001 * (float)(t - audioPeakTime);
  return p > 0?p:0;
}