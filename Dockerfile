FROM node:16
RUN npm install -g pnpm
COPY dashboard /dashboard
WORKDIR /dashboard
RUN pnpm install
RUN echo "Node.js, pnpm, and application dependencies installed successfully."
CMD ["pnpm", "run", "dev"]
