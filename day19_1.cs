// $ [brew install mono|apt-get install mono-complete|yum install mono-complete]
// $ mcs day19_1.cs && mono day19_1.exe

using System;
using System.Collections.Generic;
using System.Net;
using static System.Tuple;

class Day19
{
  class Cursor
  {
    public int x;
    public int y;
    public string direction = "down";
    public List<string> seenLetters = new List<string>();

    public Cursor() {}

    public void traverseGrid(ref List<List<string>> grid) {
      var encounteredChar = grid[grid.Count - this.y - 1][this.x];
      if (encounteredChar != "-" && encounteredChar != "|") {
        if (encounteredChar != "+") this.seenLetters.Add(encounteredChar);
        if (!this.findNextDirection(ref grid)) return;
      }
      this.move();
      this.traverseGrid(ref grid);
    }

    private bool findNextDirection(ref List<List<string>> grid) {
      var options = new Dictionary<string, int[]>{
        ["up"]    = new int[]{ this.x,   this.y+1 },
        ["down"]  = new int[]{ this.x,   this.y-1 },
        ["right"] = new int[]{ this.x+1, this.y   },
        ["left"]  = new int[]{ this.x-1, this.y   }
      };

      var excludedOppositeDirection = new int[]{ -1, -1 };
      switch (this.direction)
      {
        case "up":    options["down"]  = excludedOppositeDirection; break;
        case "down":  options["up"]    = excludedOppositeDirection; break;
        case "right": options["left"]  = excludedOppositeDirection; break;
        case "left":  options["right"] = excludedOppositeDirection; break;
      }

      var maxX = grid[0].Count - 1;
      var maxY = grid.Count - 1;
      foreach(var option in options) {
        var optX = option.Value[0];
        var optY = option.Value[1];
        if (optX < 0 || optY < 0 || optX > maxX || optY > maxY) { continue; }
        else if (grid[maxY - optY][optX] != " ") {
          this.direction = option.Key;
          return true;
        }
      }
      return false;
    }

    private void move() {
      switch (this.direction)
      {
        case "up":    this.y++; break;
        case "down":  this.y--; break;
        case "right": this.x++; break;
        case "left":  this.x--; break;
      }
    }
  }

  static void Main()
  {
    var grid = parseInputIntoGrid();

    var cursor = new Cursor();
    var start = findStart(ref grid);
    cursor.x = start.Item1;
    cursor.y = start.Item2;
    cursor.traverseGrid(ref grid);

    Console.WriteLine($"Seen letters: {string.Join("", cursor.seenLetters)}");
  }

  static Tuple<int, int> findStart(ref List<List<string>> grid) {
    return Tuple.Create(grid[0].IndexOf("|"), grid.Count - 1);
  }

  static List<List<string>> parseInputIntoGrid()
  {
    var wc = new WebClient();
    var input = wc.DownloadString("https://gist.githubusercontent.com/janosch-x/5937a11276e3e95edaa20d8549b43ec3/raw/cf2eb10b68c0f48255cb143c959564d98f949fa3/input.txt");

    var grid = new List<List<string>>();
    foreach (var line in input.Split('\n')) {
      var row = new List<string>();
      foreach(char chr in line) { row.Add("" + chr); }
      grid.Add(row);
    }
    return grid;
  }
}
