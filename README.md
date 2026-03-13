# Tennis Kata

This Kata is about implementing a tennis game. Originally taken from [CodingDojo](https://codingdojo.org/kata/Tennis/).

In this kata we will be focussing on "Functional Programming".

## Functional Calisthenics
Because the words "Functional Programming" mean different things to different people, I've come up with a set of rules to force what *I* think about when I say "Functional Programming". Feel free to ignore the term "Functional Programming", and instead think of it as a deliberate constrain.

1. No mutable state. No reassignment.
2. [Pure functions](https://en.wikipedia.org/wiki/Pure_function) internally.
3. Side effects only at the boundaries.
4. No loops. Use recursion, `map`, `fold`, or other [higher-order functions](https://en.wikipedia.org/wiki/Higher-order_function).
5. No `null`.
6. [Expressions](https://en.wikipedia.org/wiki/Expression_(computer_science)), not Statements. _All lines should return a value._

The term is a nod to *Object Calisthenics*. A set of 9 rules invented by Jeff Bay in their book **The ThoughtWorks Anthology** for "[…] better software design today".


### But my language is not a functional language

Even though this is "Functional Programming" kata, it does not mean that you can't use objects, or any abstraction that your programming language allows. Just keep in mind the Functional Calisthenics.

Do note that languages copy useful abstractions from each other, so do spend some time exploring the available abstractions.

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

## Takeaways

When doing this kata, thinking about Functional Programming, I tend to ponder these questions:

1. What should happen if a player scores a point, and the game was already won?
2. What is the _boundary_ of this kata? What is pure, and what needs side effects?

### Why Functional Programming?

Functional programming helps me think about code in a different way.

**Pattern Recognition**: Higher-order functions (`map`, `fold`, `filter`) reveal common patterns hidden in loops. It also provides a richer vocabulary for communicating software design.

**Data Flow Over Control Flow**: By avoiding intermediate variables and using pipelines (`data |> transform |> render`), the flow of information becomes explicit.

**Reasoning by Substitution**: Pure functions let you reason locally. If `f(x) = y` always, you can replace `f(x)` with `y` anywhere. No hidden state, no action at a distance. I find refactoring less daunting, and debugging easier.
