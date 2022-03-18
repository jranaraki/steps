/*
* Copyright (C) 2022  Javad Rahimipour Anaraki
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; version 3.
*
* steps is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
