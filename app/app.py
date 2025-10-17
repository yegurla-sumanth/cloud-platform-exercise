from flask import Flask, jsonify
import os, random, logging

app = Flask(__name__)

# Basic logging to stdout so it lands in CloudWatch Logs
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

CAT_GIFS = [
    "https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif",
    "https://media.giphy.com/media/mlvseq9yvZhba/giphy.gif",
    "https://media.giphy.com/media/3oriO0OEd9QIDdllqo/giphy.gif",
    "https://media.giphy.com/media/13borq7Zo2kulO/giphy.gif"
]

ALARM_MATCH = os.environ.get("ALARM_MATCH_STRING", "ALERT_TRIGGER")

@app.route("/")
def index():
    # Write the match string to logs so the metric filter can count it
    logger.info(f"app_heartbeat {ALARM_MATCH}")
    gif = random.choice(CAT_GIFS)
    return jsonify({"message": "hello from catgif app", "gif": gif})

@app.route("/healthz")
def health():
    return "ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "80")))
