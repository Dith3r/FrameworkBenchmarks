FROM tfb/nginx:latest

FROM tfb/python3:latest

COPY --from=0 /nginx /nginx

ENV NGINX_HOME="/nginx"
ENV PATH=/nginx/sbin:${PATH}

ADD ./ /flask

WORKDIR /flask

RUN pip3 install --install-option="--prefix=${PY3_ROOT}" -r /flask/requirements.txt

RUN sed -i 's|include .*/conf/uwsgi_params;|include '"${NGINX_HOME}"'/conf/uwsgi_params;|g' /flask/nginx.conf

CMD nginx -c /flask/nginx.conf && uwsgi --ini /flask/uwsgi.ini --processes $((CPU_COUNT*3)) --wsgi app:app