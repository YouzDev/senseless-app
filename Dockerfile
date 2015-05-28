FROM rails:onbuild

RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
