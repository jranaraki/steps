/*
 * uNav http://launchpad.net/unav
 * Copyright (C) 2015 JkB https://launchpad.net/~joergberroth
 * Copyright (C) 2015 Marcos Alvarez Costales https://launchpad.net/~costales
 *
 * uNav is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * uNav is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */
// Thanks http://askubuntu.com/questions/352157/how-to-use-a-sqlite-database-from-qml


function openDB() {
    var db = LocalStorage.openDatabaseSync("storedsteps_db", "1.0", "Stored Steps", 1000);
    try {
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS storedsteps( date TEXT PRIMARY KEY, steps INTEGER, distance REAL )');
        });
    } catch (err) {
        console.log("Error creating table in database: " + err)
    } return db
}

function storeSteps(date, steps, distance) {
    var db = openDB();
    db.transaction(function(tx){
        tx.executeSql('INSERT OR REPLACE INTO storedsteps (date, steps, distance) VALUES(?, ?, ?)', [date, steps, distance]);
    });
}

function updateStoredSteps(id, modified, url, desc) {
    var db = openDB();

    db.transaction(function(tx){
        tx.executeSql('UPDATE storedsteps SET date=?, steps=?, distance=? WHERE identifier=?;', [modified, url, desc, id]);
    });
}

function getSteps() {
    var db = openDB();
    var rs;
    db.transaction(function(tx) {
        rs = tx.executeSql('SELECT * FROM storedsteps');
    });

    return rs
}

function findStep(date) {
    var db = openDB();
    var rs;
    db.transaction(function(tx) {
        rs = tx.executeSql('SELECT * FROM storedsteps WHERE date like ?;', [date]);
    });

    return rs
}

function deleteSteps(id){
    console.log("Deleting register id: " + id);
    var db = openDB();
    db.transaction(function(tx){
        tx.executeSql('DELETE FROM storedsteps WHERE date=?;', [id]);
    });
}
