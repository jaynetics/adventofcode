<?php
  class PassphraseCounter
  {
    public function count_correct($input)
    {
      $count = 0;
      foreach (explode(PHP_EOL, $input) as $line) {
        $words = explode(' ', trim($line));
        if (array_unique($words) == $words) $count++;
      }
      return $count;
    }
  }

  $passphrase_counter = new PassphraseCounter;

  $input = <<<EOT
... paste input here ...
EOT;

  echo $passphrase_counter->count_correct($input);
