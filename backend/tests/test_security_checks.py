import unittest
from app.security_checks import check_sql_injection


class TestSQLInjection(unittest.TestCase):
    def test_safe_url(self):
        safe_url = "http://example.com"
        result = check_sql_injection(safe_url)
        self.assertEqual(result["status"], "safe")

    def test_vulnerable_url(self):
        # Simulieren einer verwundbaren URL (z. B. durch einen lokalen Mock-Server)
        vulnerable_url = "http://vulnerable.com"
        result = check_sql_injection(vulnerable_url)
        self.assertIn("status", result)
