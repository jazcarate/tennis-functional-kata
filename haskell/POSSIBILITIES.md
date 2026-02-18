# Haskell Tennis Kata – Possibilities

A kata is not something that you can "solve". But here are some alternatives on how you can approach modeling this kata.

1. **Union** - Represent the game as a [union](https://en.wikipedia.org/wiki/Union_type) of possible states. Scoring a point is transitioning between these states. See [Haskell/Tennis/Union.hs](Haskell/Tennis/Union.hs)

2. **Fold** / Event Sourcing - Represent the game as an ordered collection of points, and derive the score by walking ([fold](https://en.wikipedia.org/wiki/Fold_(higher-order_function))) though the points. See [Haskell/Tennis/Fold.hs](Haskell/Tennis/Fold.hs)

3. **Lens** / Multiple Views - Represent the game as two numbers, and have different ways of _looking_ ([Lens](https://en.wikibooks.org/wiki/Haskell/Lenses_and_functional_references)) at the score, _choosing_ the correct one. See [Haskell/Tennis/Lens.hs](Haskell/Tennis/Lens.hs)

4. **State as Functions** - Represent the game as the transitions themselves. For example, At love-love, the game is a function that knows: If Player1 scores, I become fifteen-love. If Player2 scores, I become love-fifteen. See [Haskell/Tennis/Function.hs](Haskell/Tennis/Function.hs)
