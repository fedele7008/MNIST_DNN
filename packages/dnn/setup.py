import io
import setuptools

def long_description():
    with io.open('README.md', 'r', encoding='utf-8') as f:
        readme = f.read()
    return readme

def requirements():
    with io.open('requirements.txt', 'r', encoding='utf-8') as f:
        requirements = f.read()
    return requirements

setuptools.setup(
    name='mnist-dnn',
    version='0.1.2',
    author='John Yoon',
    author_email='fedelejohn7008@gmail.com',
    description='Deep Neural Network from Scratch with MNIST dataset',
    long_description=long_description(),
    long_description_content_type='text/markdown',
    url='https://github.com/fedele7008/MNIST_DNN',
    project_urls={
        'Issue Tracker': 'https://github.com/fedele7008/MNIST_DNN/issues',
        'Wiki': 'https://github.com/fedele7008/MNIST_DNN/wiki'
    },
    classifiers=[
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.11',
        'License :: OSI Approved :: MIT License'
    ],
    install_requires=requirements(),
    setup_requires=[],
    package_dir={'': 'src'},
    packages=setuptools.find_packages(where='src'),
    include_package_data=True,
    python_requires='>=3.6',
    zip_safe=False
)