import java.util.List;
import java.util.Stack;
import java.util.Random;


public final Integer WALL = 2;
public final Integer VISITED = 1;
public final Integer UNVISITED = 0;

public final Integer PLAYER = 0;
public final Integer FREE_SPACE = 1;
public final Integer NPC_PLACE = 3;


public List<Integer[]> generateWalls(Integer width, Integer height) {
  
  Integer[][] labirint = generateLabirint(width, height);
  
  List<Integer[]> walls = generateWalls(labirint);
  return walls;
}

public List<Integer[]> generateWalls(Integer[][] labirint) {
  List<Integer[]> walls = new ArrayList<Integer[]>();
  
  for (int i = 0; i < labirint.length; i++) {
    Integer start = 0;
    Integer end = -1;
    while(start < labirint[i].length){
      while(labirint[i].length > end + 1 && labirint[i][end+1] == WALL ) {
        end++;
      }
      if (end - start > 1) {
        Integer[] wall = new Integer[4];
        wall[0] = i;
        wall[1] = start;
        wall[2] = i;
        wall[3] = end;
        walls.add(wall);
      }
      start = end + 2;
      end = start;
    }
  }
  
  for (int i = 0; i < labirint[0].length; i++) {
    Integer start = 0;
    Integer end = -1;
    while(start < labirint.length){
      while(labirint.length > end + 1 && labirint[end+1][i] == WALL) {
       end++;
      }
      if (end - start > 1) {
        Integer[] wall = new Integer[4];
        wall[0] = start;
        wall[1] = i;
        wall[2] = end;
        wall[3] = i;
        walls.add(wall);
      }
      start = end + 2;
      end = start;
    }
  }
  
  return walls;
}

public List<Integer[]> generateChordsForObjectInFreeSpace(Integer npcSize, Integer[][] labirint) {
  List<Integer[]> mobs = new ArrayList<Integer[]>();
  
  Integer[][] temporaryLabirint = labirint.clone();
  
  Random random = new Random(new Date().getTime());//создали рандомизатор
  
  for (int i = 0; i < npcSize; i++) {
    Integer[]  newChords = new Integer[2];
    newChords[0] = random.nextInt(temporaryLabirint.length);
    newChords[1] = random.nextInt(temporaryLabirint[0].length);
    if (temporaryLabirint[newChords[0]][newChords[1]] != FREE_SPACE) {
      i--;
      continue;
    }
    temporaryLabirint[newChords[0]][newChords[1]] = NPC_PLACE;
    mobs.add(newChords);
  }
  
  Integer[] playerChords = new Integer[2];
  while (true) {
    playerChords[0] = random.nextInt(temporaryLabirint.length);
    playerChords[1] = random.nextInt(temporaryLabirint[0].length);
    if (temporaryLabirint[playerChords[0]][playerChords[1]] != FREE_SPACE) {
      continue;
    }
    temporaryLabirint[playerChords[0]][playerChords[1]] = PLAYER; 
    mobs.add(playerChords);
    break;
  }
  
  return mobs;
}

public Integer[][] generateLabirintWithQuit(Integer width, Integer height) {
  Integer[][] labirint = generateLabirint(width, height);
  
  //Random random = new Random(new Date().getTime());//создали рандомизатор
  
  //Integer[] quitChords = new Integer[2];
  
  //Integer edgeChord = random.nextInt(2);
  
  //Integer otherChord = 1 - edgeChord;
  
  //quitChords[edgeChord] = random.nextInt(2) == 1 ? 0 : (edgeChord == 1 ? height : width);
  
  //Integer sum = otherChord == 0 ? width : height ;
  
  //while (true) {
  //  quitChords[otherChord]  = random.nextInt(sum);
  //  if (quitChords[otherChord] % 2 != 0 && quitChords[otherChord] > 0 && quitChords[otherChord] < sum) {
  //    break;
  //  }
  //}
  
  //System.out.println(quitChords[0]);
  //System.out.println(quitChords[1]);
  
  //labirint[quitChords[0]][quitChords[1]] = FREE_SPACE;
  
  labirint[0][1] = FREE_SPACE;
  
  return labirint;
}

public Integer[][] generateLabirint(Integer width, Integer height) {
  
  Random random = new Random(new Date().getTime());//создали рандомизатор
  
  Integer[][] labirint = generateNet(width, height);
   
  Stack<Integer[]> visitedPoints = new Stack<Integer[]>();
  
  Integer[] startChords = new Integer[2];
  while (true) {
    startChords[0] = random.nextInt(width);
    if (startChords[0] % 2 != 0 && startChords[0] != 0 && startChords[0] != height) {
      break; 
    }
  }
  while (true) {
    startChords[1] = random.nextInt(height);
    if (startChords[1] % 2 != 0 && startChords[1] != 0 && startChords[1] != width) {
      break; 
    }
  }
  
  labirint[startChords[0]][startChords[1]] = VISITED;
  
  visitedPoints.push(startChords);
   
  labirint = generateNet(width, height);
  
  
  while(true) {
   if (visitedPoints.size() == 0) {
    break; 
   }
   Integer[] currentPoint = visitedPoints.peek();//подсмотрели значение сверху
   Integer[] nextPosition = currentPoint.clone();//склонировали позицию
   List<int[]> possibleNextPositions = new ArrayList<int[]>();//создали список возможно следующих шагов
    
   for (int i = -1; i < 2; i += 2) {//x -1 1
     if (currentPoint[1] + i*2 > 0 && currentPoint[1] + i*2 < height) {
       int[] possiblePosition = new int[4];
       possiblePosition[0] = currentPoint[0];
       possiblePosition[1] = currentPoint[1] + i;
       possiblePosition[2] = 0;//modifier i
       possiblePosition[3] = i;//modifier j
       possibleNextPositions.add(possiblePosition);
     }
     
     if (currentPoint[0] + i*2 > 0 && currentPoint[0] + i*2 < width) {
       int[] possiblePosition = new int[4];
       possiblePosition[0] = currentPoint[0] + i;
       possiblePosition[1] = currentPoint[1];
       possiblePosition[2] = i;//modifier i
       possiblePosition[3] = 0;//modifier j
       possibleNextPositions.add(possiblePosition);
     }
   }
    
    
    
   while (true) {
      
     if (possibleNextPositions.isEmpty()) {
       for (int i = 0; i < 2 && visitedPoints.size() > 0; i++){
         visitedPoints.pop();
       }
        break;
     }
      
     Integer tryNextPosition = random.nextInt(possibleNextPositions.size());
      
     Integer nextX = possibleNextPositions.get(tryNextPosition)[0];
     Integer nextY = possibleNextPositions.get(tryNextPosition)[1];
     Integer modifierX = possibleNextPositions.get(tryNextPosition)[2];
     Integer modifierY = possibleNextPositions.get(tryNextPosition)[3];
      
     if (labirint[nextX][nextY] == VISITED || labirint[nextX + modifierX][nextY + modifierY] == VISITED ) {
       possibleNextPositions.remove(possibleNextPositions.get(tryNextPosition));
       continue; 
     }
      
     nextPosition[0] = nextX;
     nextPosition[1] = nextY;
      
     labirint[nextPosition[0]][nextPosition[1]] = VISITED;
      
     visitedPoints.push(nextPosition);
      
     nextPosition[0] = nextX + modifierX;
     nextPosition[1] = nextY + modifierY;
      
     labirint[nextPosition[0]][nextPosition[1]] = VISITED;
      
     visitedPoints.push(nextPosition);
      
     break;
   }
  }
  return labirint;
}

public Integer[][] generateNet(int width, int height) {
  Integer[][] net = new Integer[width][height];
  
  for (int i = 0; i < width; i++){
     for (int j = 0; j < height; j++) {
       if (i%2 == 0 || j%2 == 0) {
         net[i][j] = WALL;
         continue;
       }
       net[i][j] = UNVISITED;
     }
  }
  
  return net;
}