# Election
Processes elections with consensus-based preferences

Takes a list of ballots and, like [Tideman Voting](https://en.wikipedia.org/wiki/Ranked_pairs) locks strongest preferences, except if they cause a cycle. However, does not assume that failure to vote means you rank that item last, assumes that you have no knowledge of that item. 

That is, if person 1 provides [A,B] and person 2 provides [B,C], the ranking will be [A,B,C]. Presumably person B, if unhappy with the ranking, can go back and evaluate A.

Doesn't yet allow ties to be input, but there's nothing in the algorithm that should preclude preferences with ties.

Particularly well suited for combining preferences where consensus is assumed among the rankers, but not all rankers will observe all things. Applications include journal articles, hiring decisions, etc.

Also provides a scotty API, which I hook up to google sheets. 

Pull requests welcome. I build it with ghc 7.10, I can't promise it'll work with anything older.

Algorithm:

1. Determine pairwise preference strength of each pair of candidates

2. Lock preferences in order of preference strength, unless a cycle would result, in which case discard preferences adding cycles.

3. The item beating the most other items can be inferred to be the "winner".
