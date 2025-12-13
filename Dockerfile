# Use lightweight nginx to serve static files
FROM nginx:stable-alpine

# Remove default html files
RUN rm -rf /usr/share/nginx/html/*

# Copy built static files (dist) into nginx html dir
COPY dist/ /usr/share/nginx/html/

# Replace default nginx conf to listen on 3000
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose 3000
EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
