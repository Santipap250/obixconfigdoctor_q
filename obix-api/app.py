from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return {"status": "OBIX API online"}

@app.route("/analyze", methods=["POST"])
def analyze():
    data = request.json

    result = {
        "input": data,
        "analysis": {
            "thrust_estimate": "OK",
            "battery_time": "6-8 min",
            "rating": "GOOD"
        }
    }
    return jsonify(result)

if __name__ == "__main__":
    app.run()

