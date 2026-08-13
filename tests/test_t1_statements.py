"""T1 readiness: the candidate is a non-empty Prop term string. No Lean."""

from __future__ import annotations

import unittest

from t1.statements import CAP_SET_BEAT_CUBE, UNIVERSE_CONTROL


class T1StatementTests(unittest.TestCase):
    def test_cap_set_mentions_fence_carriers(self) -> None:
        s = CAP_SET_BEAT_CUBE
        self.assertIn("ZMod 3", s)
        self.assertIn("Fin n", s)
        self.assertIn("Finset", s)
        self.assertIn("2 ^ n", s)
        self.assertNotIn("Type u", s)
        self.assertNotIn("Type*", s)

    def test_universe_control_is_polymorphic(self) -> None:
        self.assertIn("Type*", UNIVERSE_CONTROL)


if __name__ == "__main__":
    unittest.main()
