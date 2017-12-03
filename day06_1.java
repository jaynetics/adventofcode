// $ mv day06_1.java Day61.java && javac Day61.java && java Day61 -Xss8m

import java.util.Arrays;
import java.util.ArrayList;
import java.util.stream.IntStream;
import java.util.function.Function;

public class Day61 {
  public static class Recursive<I> {
    public I func;
  }

  public static void main(String args[]) {
    int[] input = {11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11};

    Function<int[], Integer> getMax =
      array -> Arrays.stream(array).max().getAsInt();

    Function<Integer, Function<int[], Integer>> getIndex =
      needle -> haystack -> IntStream.range(0, haystack.length)
                                     .filter(i -> haystack[i] == needle)
                                     .findFirst().orElse(-1);

    ArrayList<int[]> memory = new ArrayList<int[]>();

    Recursive<Function<int[], int[]>> distribute = new Recursive<>();

    distribute.func =
      array -> {
        for (int[] previous : memory) {
          if (Arrays.equals(previous, array)) return array;
        }
        memory.add(array);

        int max = getMax.apply(array);
        int maxIndex = getIndex.apply(max).apply(array);

        int[] newArray = array.clone();
        newArray[maxIndex] = 0;

        int dstIndex = maxIndex + 1;

        for (int toDistribute = max; toDistribute > 0; toDistribute--) {
          if (dstIndex == newArray.length) dstIndex = 0;
          newArray[dstIndex]++;
          dstIndex++;
        }

        return distribute.func.apply(newArray);
      };

    distribute.func.apply(input);

    System.out.println("steps taken: " + memory.size());
  }
}
