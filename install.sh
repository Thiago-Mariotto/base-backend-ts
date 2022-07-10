
#install npm dependencies
packages=("express")
clear

echo "# Base package.json has created"
echo "$(tput setaf 3)Do you need a database? y/n?"

read useDb

if [ "$useDb" = "y" ] || [ "$useDb" = "Y" ]; then
	echo "\n-> Do you use a ORM?" y/n

	read useORM

	if [ "$useORM" = "y" ] || [ "$useORM" = "Y" ]; then
		echo "\n-> What's your ORM?"
		orms=("TypeORM" "Sequelize" "Other")

		select opt in "${orms[@]}"
		do
			case $opt	in
				"TypeORM")
					echo "Selected ${opt}"
					orm="typeorm"
					break
					;;
				"Sequelize")
					echo "Selected ${opt}"
					orm="sequelize"
					break
					;;
				"None of This")
					echo "No option selected."
					echo "Install manualy your ORM"
					break
					;;
				*) echo "Unknown option $REPLY"
			esac
		done
	else 
		echo "No using ORM"
	fi

	echo "\n-> Select the database to use"
	dbs=("MySQL" "PostgreSQL" "MongoDB" "SQLite" "Other")

	select opt in "${dbs[@]}"
		do
			case $opt	in
				"MySQL")
					echo "Selected ${opt}"
					db="mysql2"
					db="mysql"
					break
					;;
				"PostgreSQL")
					echo "Selected ${opt}"
					db="pg"
					db="pg"
					break
					;;
				"Sqlite")
					echo "Selected ${opt}"
					db="sqlite3"
					break
					;;
					"MongoDB")
					echo "Selected ${opt}"
					db="mongodb"
					db="mongodb"
					break
					;;
				"Other")
					echo "No option selected."
					echo "Install manualy your database."
					break
					;;
				*) echo "Unknown option $REPLY"
			esac
		done
else
	echo "No using database ..."
fi

echo "\n-> You can use TypeScript? y/n"

read useTypescript

if [ "$useTypescript" = "y" ] || [ "$useTypescript" = "Y" ]; then
	file="ts"
	echo "\n$(tput setaf 2)Typescript added successfully"
		ts=("typescript")
else
	echo "No using typescript"
	file="js"
fi

echo "$(tput setaf 2)This project use express framework$(tput setaf 3)"

echo "\n$(tput setaf 6)Installing packages ..."
npm install express dotenv $orm $db --silent
echo "$(tput setaf 2)Install dependencies successfully"


if [ "$ts" ]; then
	echo "\n$(tput setaf 6)Installing developments packages ..."
	npm install --silent --save-dev "@types/express" "typescript" "@types/${orm}" "@types/${db}"
	echo "$(tput setaf 2)Install dev dependencies successfully"
fi

echo "$(tput setaf 6)Initializing Typescript..."
npx tsc --init
echo "$(tput setaf 2)Typescript initialized"
echo "$(tput setaf 4)Please config your Typescript file after installing."

echo "$(tput setaf 3)\n-> You can use layers architecture with Model Controller and Service? y/n"
read msc

if [ "$msc" = "y" ] || [ "$msc" = "Y" ] ; then

	echo "$(tput setaf 6)Creating folder ..."
	mkdir src
	mkdir ./src/controllers
	echo "// your controllers here" >> ./src/controllers/index.${file}
	mkdir ./src/models
	echo "// your models here" >> ./src/models/index.${file}
	mkdir ./src/services
	echo "// your services here" >> ./src/services/index.${file}
	mkdir ./src/routes

	if [ "$file" = "ts" ]; then
		echo "import express, {Request, Response, NextFunction} from 'express';\n
const router = express.Router();\n
router.get('/', (req: Request, res: Response, next: NextFunction) => res.send('Successfully'))
export default router;" >> ./src/routes/index.${file}

		echo "import express from 'express';\n
import router from './routes';\n
const app = express();\n
app.use(express.json);\n
app.use(router);\n
export default app;" >> ./src/app.${file}

		echo "import app from './app';\n
import dotenv from 'dotenv';\n
dotenv.config();\n\n
const PORT = process.env.PORT || 3001;\n\n
app.listen(PORT, () => console.log(\`Service listen on port \${PORT}\`));" >> ./src/index.${file}
	
	else
		echo "const express, {Request, Response, NextFunction} = require('express');\n
const router = express.Router();\n
router.get('/', (req, res, next) => res.send('Successfully'))
export default router;" >> ./src/routes/index.${file}

		echo "const express = require('express');\n
const router = require('./routes');\n
const app = express();\n
app.use(express.json);\n
app.use(router);\n\n
module.exports = app;" >> ./src/app.${file}

		echo "const app = require('./app')';\n
const dotenv = require('dotenv');\n
dotenv.config();\n
const PORT = process.env.PORT || 3001;\n
app.listen(PORT, () => console.log(\`Service listen on port \${PORT}\`));" >> ./src/index.${file}
	fi

	echo "$(tput setaf 2)Folders created successfully$"
fi

echo "Initializing .git repository."
git init

echo "\n$(tput setaf 6)-> Creating .env file"
echo "PORT=3001" >> .env

echo "\n-> You can use Eslint? [y/N]"
read eslint

if [ "$eslint" = "y" ] || [ "$eslint" = "Y" ]; then
	npm install eslint --save-dev
	npx eslint --init
fi

echo "$(tput setaf 2)Eslint added successfully."
echo "Finalizing script ..."