# Build step
FROM node:18 AS build

WORKDIR /app

# Copiar el archivo package json y lock para aprovechar el cache
COPY package*.json ./

# Instalamos las dependencias
RUN npm install

# Copiamos el resto de archivos
COPY . .

# Generamos los archivos estaticos
RUN npm run build

# Prod step
FROM node:18 AS production

WORKDIR /app

#Copiamos los archivos necesarios
COPY --from=build /app/package*.json ./
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public

# Instalamos las dependencias de prod
RUN npm install --only=production

# Exponer el puerto
EXPOSE 3000

# Iniciamos la app
CMD [ "npm","start" ]