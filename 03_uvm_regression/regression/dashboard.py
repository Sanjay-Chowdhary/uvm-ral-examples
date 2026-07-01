#!/usr/bin/env python3

"""
Regression Dashboard
Displays test results in a beautiful dashboard
"""

import json
import os
from datetime import datetime

class Dashboard:
    def __init__(self):
        self.reports_dir = "results/reports"
        
    def display(self):
        report_file = os.path.join(self.reports_dir, "results.json")
        
        if not os.path.exists(report_file):
            print("❌ No results found. Run regression first.")
            return
        
        with open(report_file, 'r') as f:
            results = json.load(f)
        
        self.print_dashboard(results)
        
    def print_dashboard(self, results):
        total = results["passed"] + results["failed"]
        pass_rate = (results["passed"] / total * 100) if total > 0 else 0
        
        print("╭" + "─" * 60 + "╮")
        print("│" + " " * 60 + "│")
        print("│" + "UVM REGRESSION TEST DASHBOARD".center(60) + "│")
        print("│" + " " * 60 + "│")
        print("├" + "─" * 60 + "┤")
        print("│ SUMMARY" + " " * 52 + "│")
        print("│ " + "-" * 58 + " │")
        print("│ Total Tests:    {:3d}                              │".format(total))
        print("│ Passed:         {:3d} {} ({:.1f}%)                      │".format(results["passed"], "✓", pass_rate))
        print("│ Failed:         {:3d} {} ({:.1f}%)                      │".format(results["failed"], "✗", 100-pass_rate))
        print("│ " + "-" * 58 + " │")
        print("│ TEST RESULTS" + " " * 47 + "│")
        print("│ " + "-" * 58 + " │")
        
        for test in results["tests"]:
            status_icon = "✓" if test["status"] == "PASS" else "✗"
            status_color = "PASS" if test["status"] == "PASS" else "FAIL"
            print("│ {} {:40s} [{}]".format(status_icon, test["name"], status_color) + " " * (13 - len(status_color)) + "│")
        
        print("│ " + "-" * 58 + " │")
        print("│ Timestamp: " + results["timestamp"] + " " * (47 - len(results["timestamp"])) + "│")
        print("╰" + "─" * 60 + "╯")
        print()

if __name__ == "__main__":
    dashboard = Dashboard()
    dashboard.display()
