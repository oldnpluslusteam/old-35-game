import java.util.List;
import java.util.Stack;
import java.util.Random;


public final Integer WALL = 2;
public final Integer VISITED = 1;
public final Integer UNVISITED = 0;


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
   if (visitedPoints.size() == 0) { //<>//
    break; 
   }
   Integer[] currentPoint = visitedPoints.peek();//подсмотрели значение сверху
   Integer[] nextPosition = currentPoint.clone();//склонировали позицию
   List<int[]> possibleNextPositions = new ArrayList<int[]>();//создали список возможно следующих шагов
    
   for (int i = -1; i < 2; i += 2) {//x -1 1
     if (currentPoint[1] + i*2 > 0 && currentPoint[1] + i*2 < height) {
       int[] possiblePosition = new int[4]; //<>//
       possiblePosition[0] = currentPoint[0];
       possiblePosition[1] = currentPoint[1] + i; //<>//
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
      
     if (possibleNextPositions.isEmpty()) { //<>//
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
  
  for (int i = 0; i < height; i++){
     for (int j = 0; j < width; j++) {
       if (i%2 == 0 || j%2 == 0) {
         net[i][j] = WALL;
         continue;
       }
       net[i][j] = UNVISITED;
     }
  }
  
  return net;
}