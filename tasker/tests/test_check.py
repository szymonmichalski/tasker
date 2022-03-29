from django.test import TestCase


class TestCheck(TestCase):
    def setUp(self):
        pass

    def test_check(self):
        self.assertEqual(2 + 2, 4)
