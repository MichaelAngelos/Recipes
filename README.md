# Recipes

## Backend

### Git Clone the Recipes Repository

Inside the `backend` folder, run `npm i` to install all the packages used in the backend of the application. The backend is now ready; its usage will be explained later.

Create a connection through MySQL Workbench to the IP `127.0.0.1` with the username `root` and a blank password.

From the `backend` folder, open the three files: `ddl_recipes.sql`, `load_data.sql`, and `dml_recipes.sql`.

- The `ddl_recipes.sql` file creates the tables and views.
- The `load_data.sql` file contains the code to load data from the dummy data files into the tables.
- The `dml_recipes.sql` file creates the procedures and triggers necessary for operations and query solutions.

Run the `ddl_recipes.sql` and `dml_recipes.sql` files to create the tables.

To load the data, copy and paste all the TSV files from the `backend/dummy_data_v2` folder into the database folder in XAMPP.

Depending on whether XAMPP is installed on the C or D drive, the folder will be `C:\xampp\mysql\data\recipes` or the corresponding folder on the D drive.

With the TSV files inside the `recipes` folder, run the `load_data.sql` file.

Now the data is loaded, and the database is ready to accept queries either from Workbench via the `queries.sql` file or from the backend.

For the backend, there is a Postman collection in the main folder of the repository. Importing this collection will display all the existing endpoints with explanations and examples.

To run the requests, you need to start the server by running the command `npm run dev` in the `backend` folder. 

