use strict;
use warnings;
use lib 't/lib';
use Test::More tests => 18;

use Parent;
use Child;
use Grandchild;

use I::Parent;
use I::Child;
use I::Grandchild;

my @want = (
  Parent     => { a => \"1\n",   b => \"2\n",  c => \"3\n" },
  Child      => {                b => \"22\n", c => \"33\n", d => \"44\n" },
  Grandchild => { a => \"111\n",                             d => \q{}    },
);

for (my $i = 0; $i < @want; $i += 2) {
  for my $prefix ('', 'I::') {
    is_deeply(
      "$prefix$want[ $i ]"->local_section_data,
      $want[ $i + 1 ],
      "$prefix$want[$i]->local_section_data"
    );
  }

  is_deeply(
    "$want[ $i ]"->merged_section_data,
    $want[ $i + 1 ],
    "$want[$i]->merged_section_data"
  );
}

is_deeply(Parent    ->section_data('a'), \"1\n",   "Parent's a");
is_deeply(Parent    ->section_data('b'), \"2\n",   "Parent's b");
is_deeply(Grandchild->section_data('a'), \"111\n", "Grandchild's a");
is_deeply(Grandchild->section_data('b'), undef,   "Grandchild's b (none)");

is_deeply(I::Parent    ->section_data('a'), \"1\n",   "I::Parent's a");
is_deeply(I::Parent    ->section_data('b'), \"2\n",   "I::Parent's b");
is_deeply(I::Grandchild->section_data('a'), \"111\n", "I::Grandchild's a");
is_deeply(I::Grandchild->section_data('b'), \"22\n",  "I::Grandchild's b (via Child)");

is_deeply(
  I::Grandchild->merged_section_data,
  { a => \"111\n", b => \"22\n", c => \"33\n", d => \q{}, },
  "I::Grandchild->merged_section_data",
)
