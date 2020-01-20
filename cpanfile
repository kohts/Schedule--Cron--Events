requires 'Time::Local' => 0;
requires 'Set::Crontab' => 0;

on 'test' => sub {
  requires 'Test::More';
  requires 'Test::Deep';
};