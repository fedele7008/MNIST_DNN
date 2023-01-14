from flask import Flask

def create_dnn_api():
    app = Flask(__name__)

    @app.route('/', method=['GET', 'POST'])
    def root():
        return 'test return 200'

    return app

if __name__ == '__main__':
    app = create_dnn_api()
    app.run(debug = True, host = 'localhost', port = 8080)