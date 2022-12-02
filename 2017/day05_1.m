// $ clang -fobjc-arc -framework Foundation day5_1.m -o tmp && ./tmp && rm tmp

#import <Foundation/Foundation.h>

NSString *input();

int main (int argc, const char *argv[]) {
  NSMutableArray *values = [@[] mutableCopy];

  for (NSString *string in [input() componentsSeparatedByString:@" "]) {
    [values addObject:@([string intValue])];
  }

  NSUInteger mazeSize = [values count];
  NSUInteger position = 0;
  NSUInteger stepsTaken = 0;

  while (position < mazeSize) {
    NSInteger currentValue = [values[position] intValue];
    values[position] = @(currentValue + 1);
    position += currentValue;
    stepsTaken++;
  }

  NSLog(@"steps taken: %tu", stepsTaken);

  return 0;
}

NSString *input() {
  return @"... paste space-separated input here ...";
}
