from flask import Flask
from flask_cors import CORS

def create_dnn_api():
    app = Flask(__name__)
    CORS(app)

    @app.route('/', methods=['GET', 'POST'])
    def root():
        return 'test return 200, OK'

    return app

if __name__ == '__main__':
    dnn_api = create_dnn_api()
    dnn_api.run(debug=True, host='0.0.0.0', port=80)
