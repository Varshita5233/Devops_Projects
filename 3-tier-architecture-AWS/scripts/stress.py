#cat > /tmp/stress.py << 'EOF'
import time
import sys

def stress(duration=60, cpu_percent=100):
    print(f"Stressing CPU at {cpu_percent}% for {duration} seconds...")
    target = cpu_percent / 100.0
    start = time.time()
    while time.time() - start < duration:
        # burn CPU for a fraction of the time
        burn_start = time.time()
        while time.time() - burn_start < target * 0.1:   # 0.1s slice
            _ = 2**20
        time.sleep(0.1 - target * 0.1)
    print("Stress test finished.")

if __name__ == "__main__":
    duration = int(sys.argv[1]) if len(sys.argv) > 1 else 60
    cpu = int(sys.argv[2]) if len(sys.argv) > 2 else 100
    stress(duration, cpu)
#EOF
#python3 /tmp/stress.py 60 100 - Run this command for the above script
