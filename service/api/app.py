from flask import Flask

def create_dnn_api():
    app = Flask(__name__)

    @app.route('/', methods=['GET', 'POST'])
    def root():
        return 'test return 200'

    return app

if __name__ == '__main__':
    dnn_api = create_dnn_api()
    dnn_api.run(debug=True, host='localhost', port=8080)