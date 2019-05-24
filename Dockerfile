FROM trzeci/emscripten as builder

ARG CV_VERSION=4.1.0

RUN curl -L https://github.com/opencv/opencv/archive/$CV_VERSION.tar.gz -o /opencv.tar.gz

RUN tar xvf /opencv.tar.gz -C / \
  && mv /opencv-$CV_VERSION /opencv

WORKDIR /opencv

RUN python ./platforms/js/build_js.py build_wasm --build_wasm
RUN python ./platforms/js/build_js.py build_js

FROM scratch

COPY --from=builder /opencv/build_js/bin/opencv.js /opencv.js
COPY --from=builder /opencv/build_wasm/bin/opencv.js /opencv-wasm.js

