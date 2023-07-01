import time
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    blue = "https://d1q6f0aelx0por.cloudfront.net/icons/docker-edition-azure6.png?"
    green = "https://d1q6f0aelx0por.cloudfront.net/icons/docker-edition-suse6.png?"
    return render_template('index.html', version="App version", image=blue)

# Dummy api
@app.route("/hello")
def hello():
    return "Hello from Python! I am version deployment"

@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/services')
def services():
    return render_template('services.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/subscribe')
def subscribe():
    time.sleep(10)
    return render_template('subscribe.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0',debug=True)
