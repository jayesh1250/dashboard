FROM node:16
RUN npm install -g pnpm
COPY . /dashboard
WORKDIR /dashboard
RUN pnpm install
RUN echo "Node.js, pnpm, and application dependencies installed successfully."
EXPOSE 3000
CMD ["pnpm", "run", "dev"]
