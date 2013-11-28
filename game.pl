#!/usr/bin/perl

## game.pl: A basic Tic-Tac-Toe game with error checking and customization of player names
##
## Usage: ./game.pl
##
## Authored by John Gannon - 11-27-2013 (v0.9)

sub print_board() {
    my $b_loc = shift;  #local var for the board
    print "PRINTING BOARD...\n\n\n";
    sleep 1; # give the gamer a chance to breath :)
    foreach (sort keys %{$b_loc}) {

	if (($_ / 3) == "1") {
	    print "$b_loc->{$_}\n";
	    print "-----\n";
	} elsif (($_ / 6) == "1") {
	    print "$b_loc->{$_}\n";
	    print "-----\n";
	} elsif (($_ / 9) == "1") {
	    print "$b_loc->{$_}\n";
	} else {
	    print "$b_loc->{$_}|";
	}

    }

}

sub pick() { # function returns 1 if the pick results in a win, 0 otherwise

    my $l_loc = shift; # the marker - X or O
    my $p_loc = shift; # the person
    my $b_loc = shift; # the board 

    do { # Loop to ensure input is valid
	print "\n$p_loc, please pick a numbered spot on the board. (I'll keep asking you until you do it right!): ";
	$spot = <STDIN>;
	chop $spot;
    } until (($b_loc->{$spot} == $spot) && ($spot =~ /^[0-9]$/) && ($b_loc->{$spot} != "X") && ($b_loc->{$spot} != "O"));

    $b_loc->{$spot} = $l_loc;

    # check winners

    for my $i (1..3) { # first check if there is a vertical line
	my $uno = $i;
	my $dos = $i+3;
	my $tres = $i+6;
	if (($b_loc->{$uno} eq $b_loc->{$dos}) && ($b_loc->{$uno} eq $b_loc->{$tres})) {
	    return 1;
	} 
    }

    for my $j (1,4,7) { # then check for a horizontal win
	my $uno = $j;
	my $dos = $j+1;
	my $tres = $j+2;
	if (($b_loc->{$uno} eq $b_loc->{$dos}) && ($b_loc->{$uno} eq $b_loc->{$tres})) {
	    return 1;
	} 
    }


    if (($b_loc->{"1"} eq $l_loc) && ($b_loc->{"5"} eq $l_loc) && ($b_loc->{"9"} eq $l_loc)) { # check 1st diagonal for a win
	return 1;
    } 

    if (($b_loc->{"3"} eq $l_loc) && ($b_loc->{"5"} eq $l_loc) && ($b_loc->{"7"} eq $l_loc)) { # check the other diagonal for a win
	return 1;
    } 

    return 0;
}

# Pre-load the board array with number values so that we can keep track of which squares are not picked. Any square with a number in it is considered
# unpicked.

%b = ("1", "1",
      "2", "2",
      "3", "3",
      "4", "4",
      "5", "5",
      "6", "6",
      "7", "7",
      "8", "8",
      "9", "9");

$ret = 0;  # used to store return value from pick function - 1 means that the pick resulted in a win so we start with 0

#### Get the names of the users

print "Name of Player 1: ";
$p1 = <STDIN>;
chop $p1;
print "Thanks, $p1. Happy to have you playing. You will be the 'X's.\n";
print "Name of Player 2: ";
$p2 = <STDIN>;
chop $p2;
print "Thanks, $p2. Happy to have you playing, too. You'll be the 'O's.\n\n\n";

# configure the associative array of players based on the names of who is playing the game

%players = ($p1, "X",
      $p2, "O");

$pc = 0; # counter to make sure we don't exceed 9 turns in a game

while(($pc < 9) && ($ret == 0)) { # while we have less than 9 turns completed and we have not had a pick resulting in a win ...
    foreach $key (sort(keys %players)) {
	&print_board(\%b);
	$ret = &pick($players{$key}, $key, \%b); 
	$pc++;

	if ($ret) { # if we have a winner
	    $winner = $players{$key};
	    print "CONGRATS to you $key -- YOU WON!!!\n";
	    last;
	} elsif ($pc == 9) { # else we need to check if this is the last turn in the game
	    last;
	}

    }
}

if ($ret == 0) { # if the pick function has never returned a 1 i.e. no pick was a winner
    print "The game is a DRAW!\n";
}

print "\nPrinting the final board...\n";
sleep 1;

&print_board(\%b);

print "THANKS FOR PLAYING! Come again soon!\n";
