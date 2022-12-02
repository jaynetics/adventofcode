<?php
  class PassphraseCounter
  {
    public function count_correct($input)
    {
      $count = 0;
      foreach (explode(PHP_EOL, $input) as $line) {
        $words = explode(' ', trim($line));
        if (array_unique($words) != $words) continue;
        if ($this->includes_anagrams($words)) continue;
        $count++;
      }
      return $count;
    }

    function includes_anagrams($words) {
      foreach ($words as $word) {
        foreach ($words as $other) {
          if ($word == $other) continue;
          if ($this->chars($word) == $this->chars($other)) return true;
        }
      }
      return false;
    }

    function chars($word) {
      $chars = str_split($word);
      sort($chars);
      return $chars;
    }
  }

  $passphrase_counter = new PassphraseCounter;

  $input = <<<EOT
... paste input here ...
EOT;

  echo $passphrase_counter->count_correct($input);
