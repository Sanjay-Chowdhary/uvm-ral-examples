#!/usr/bin/env python3

"""
Slack Notification Script
Notifies team of test results
"""

import json
import os
import sys
import argparse

def send_notification(status):
    reports_dir = "results/reports"
    report_file = os.path.join(reports_dir, "results.json")
    
    if not os.path.exists(report_file):
        print("No report found")
        return
    
    with open(report_file, 'r') as f:
        results = json.load(f)
    
    total = results["passed"] + results["failed"]
    pass_rate = (results["passed"] / total * 100) if total > 0 else 0
    
    message = f"""
    Regression Test Results
    Total: {total}
    Passed: {results['passed']} ({pass_rate:.1f}%)
    Failed: {results['failed']}
    Status: {status.upper()}
    """
    
    print(message)
    # In production, send to Slack using webhook

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--status", default="unknown")
    args = parser.parse_args()
    
    send_notification(args.status)
