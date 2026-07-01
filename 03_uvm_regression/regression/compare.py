#!/usr/bin/env python3

"""
Regression Comparison Script
Compares current results against baseline
"""

import os
import json
from datetime import datetime

class RegressionAnalyzer:
    def __init__(self):
        self.baseline_dir = "results/baseline"
        self.current_dir = "results/current"
        self.logs_dir = "results/logs"
        self.reports_dir = "results/reports"
        
    def compare(self):
        tests = [
            "test_ral_write_read",
            "test_ral_backdoor",
            "test_ral_coverage",
            "test_ral_stress",
            "test_ral_advanced"
        ]
        
        results = {
            "timestamp": datetime.now().isoformat(),
            "passed": 0,
            "failed": 0,
            "tests": []
        }
        
        for test in tests:
            log_path = os.path.join(self.logs_dir, f"{test}.log")
            
            if os.path.exists(log_path):
                with open(log_path, 'r') as f:
                    content = f.read()
                    
                passed = "FAIL" not in content and "Error" not in content
                
                results["tests"].append({
                    "name": test,
                    "status": "PASS" if passed else "FAIL"
                })
                
                if passed:
                    results["passed"] += 1
                else:
                    results["failed"] += 1
        
        self.print_report(results)
        self.save_report(results)
        
    def print_report(self, results):
        total = results["passed"] + results["failed"]
        pass_rate = (results["passed"] / total * 100) if total > 0 else 0
        
        print("")
        print("╔" + "═" * 50 + "╗")
        print("║ Regression Analysis Report" + " " * 20 + "║")
        print("╞" + "═" * 50 + "╠")
        print("║ Total Tests:      %d" % total + " " * 33 + "║")
        print("║ Passed:           %d " % results["passed"] + "✓" + " " * 35 + "║")
        print("║ Failed:           %d " % results["failed"] + "✗" + " " * 35 + "║")
        print("║ Pass Rate:        %.1f%%" % pass_rate + " " * 30 + "║")
        print("╞" + "═" * 50 + "╠")
        
        for test in results["tests"]:
            status = "✓" if test["status"] == "PASS" else "✗"
            print("║ %s %-40s %s" % (status, test["name"], "║"))
        
        print("╚" + "═" * 50 + "╝")
        print("")
        
    def save_report(self, results):
        report_file = os.path.join(self.reports_dir, "results.json")
        os.makedirs(self.reports_dir, exist_ok=True)
        
        with open(report_file, 'w') as f:
            json.dump(results, f, indent=2)
        
        print(f"Report saved: {report_file}")

if __name__ == "__main__":
    analyzer = RegressionAnalyzer()
    analyzer.compare()
