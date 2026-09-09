# Determinism checklist

For a reproducible run, keep the candidate order fixed and use aggregate integer
weights. MoonBallot never consults wall-clock time, randomness, locale settings,
network services, or external state during tabulation. The same validated profile
therefore produces the same projection arrays and IRV transcript on every target.
