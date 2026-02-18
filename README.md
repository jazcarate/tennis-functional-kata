# Tennis Kata
This Kata is about implementing a tennis game. Originally taken from [CodingDojo.](https://codingdojo.org/kata/Tennis/).

In this kata we will be focussing on "Functional Programming". 

## Functional Calisthenics
Because the words "Functional Programming" mean different things to different people, I've come up with a set of rules to force what *I* think about when I say "Functional Programming". Feel free to ignore the term "Functional Programming", and instead think of it as a deliberate constrain.

The term is a nod to *Object Calisthenics*. A set of 9 rules invented by Jeff Bay in their book **The ThoughtWorks Anthology** for "[…] better software design today". 

1. No mutable state. No reassignment.
3. [Pure functions](https://en.wikipedia.org/wiki/Pure_function) internally.
4. Side effects only at the boundaries
5. No loops.
6. No `null`.
7. Model illegal states as unrepresentable.

## The Kata

Build a scoreboard of a tennis match. The external interface should be a way to print the score to the screen. And a way to score a point for each player.

Something akin to:
```java
public interface TennisGame {
	String getScore();

	void playerOneScores();
	void playerTwoScores();
}
```

The rules for showing the score are:

> Each player can have either of these scores in a game "love" (no points) "15" (one point), "30" (two points), or "40" (three points).
> If a player has "40" and they score a point, they win the game.
> However there are special rules.
> If both players have "40" the score is "deuce".
> If the game is in deuce, the one who scores a point will have "advantage".
> If the player with advantage score the point they win the game.
> If the player without advantage scores the point they are back at deuce.

### General Concerns?

Even though this is "Functional Programming" kata, it does not mean that you can't use objects, or any abstraction that your programming language allows.

Representing the different states as inherited from a common state that know how to transition to others is a valid solution to this kata.

```java
sealed interface GameState permits PointsState, FortyState, DeuceState, AdvantageState, WonState {…}
```

## Design Concerns

1. What should happen if a player scores a point, and the game was already won? (note point 7 of Functional Calisthenics)
2. 