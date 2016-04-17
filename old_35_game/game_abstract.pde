import java.util.*;

interface DrawableEntity {
  void draw();
}

interface CollidableEntity {
  void checkCollision(CollidableEntity other);
  
  void onHit(CollidableEntity other, float ptx, float pty, float normx, float normy);
}

interface UpdatebleEntity {
  void update(float dt);
}

class World {
  static final float TUNNEL_WIDTH = 80.0;
  static final int PLAYER_SHAPE_VERTICES = 512;
  static final float PLAYER_RADIUS_BASE = 20.0;
  static final float MOB_RADIUS_BASE = 20.0;
  
  List<CollidableEntity> ces = new ArrayList();
  List<UpdatebleEntity> ues = new LinkedList();
  List<DrawableEntity> des = new LinkedList();
  Set<Object> toKill = new HashSet();
  int cTime = millis();
  
  void add(Object ent) {
    if (ent instanceof DrawableEntity)
      des.add((DrawableEntity)ent);
    if (ent instanceof CollidableEntity)
      ces.add((CollidableEntity)ent);
    if (ent instanceof UpdatebleEntity)
      ues.add((UpdatebleEntity)ent);
  }
  
  void kill(Object ent) {
    toKill.add(ent);
  }
  
  void collideCollidables() {

    for (int i = 0; i < ces.size(); ++i)
      for (int j = i+1; j < ces.size(); ++j)
        ces.get(i).checkCollision(ces.get(j));
  }
  
  void updateUpdateables() {
    int nTime = millis();
    float delta = 0.001 * (float)(nTime - cTime);
    cTime = nTime;
    
    for (Object kent : toKill) {
      ces.remove(kent);
      ues.remove(kent);
      des.remove(kent);
    }

    for (UpdatebleEntity e : ues)
      e.update(delta);
  }
  
  void drawDrawables() {
    for (DrawableEntity e : des)
      e.draw();
  }
}