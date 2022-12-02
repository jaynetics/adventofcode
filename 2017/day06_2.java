// $ mv day06_2.java Day62.java && javac Day62.java && java Day62 -Xss16m

import java.util.Arrays;
import java.util.ArrayList;
import java.util.stream.IntStream;
import java.util.function.Function;

public class Day62 {
  public static class Recursive<I> {
    public I func;
  }

  public static void main(String args[]) {
    int[] input = {11, 11, 13, 7, 0, 15, 5, 5, 4, 4, 1, 1, 7, 1, 15, 11};
    // int[] input = {0, 2, 7, 0};

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

    int[] recurringArray = distribute.func.apply(input);

    for (int index = 0; index < memory.size(); index++) {
      int[] previous = memory.get(index);
      if (Arrays.equals(previous, recurringArray)) {
        System.out.println("cycles taken: " + (memory.size() - index));
        break;
      }
    }
  }
}
