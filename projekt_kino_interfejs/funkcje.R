library("RPostgres")

open.my.connection <- function() {
  con <- dbConnect(RPostgres::Postgres(), dbname = 'projekt_kino',
                   host = 'localhost',
                   port = 5432,
                   user = 'mela',
                   password = 'ChceJesc52$')
  return(con)
}

close.my.connection <- function(con) {
  dbDisconnect(con)
}

load.clients <- function(email, haslo) {
  query <- paste0("SELECT imie, nazwisko, mail, nr_karty_czlonkowskiej FROM klient WHERE mail = '", email, "' AND haslo = '", haslo, "'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  clients <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(clients)
}

load.password <- function(email) {
  query <- paste0("SELECT haslo FROM klient WHERE mail = '", email, "'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  password <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(password)
} 

load.dates <- function() {
  query <- "SELECT data FROM seans WHERE status = 'za malo osob' OR status = 'aktywny'"
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  dates <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(dates)
}

load.free.seats <- function(id_seansu) {
  query <- paste0("SELECT CONCAT('Miejsce: ', nr_miejsca, ', Rząd: ', nr_rzedu) AS seat_info FROM wolne_miejsca WHERE id_seans = '", id_seansu, "'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  seats <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(seats)
}

load.screening.status <- function(id_res) {
  query <- paste0("SELECT s.status FROM seans s JOIN rezerwacja USING(id_seans) WHERE id_rezerwacja = '", id_res, "'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  sstatus <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(sstatus)
}

load.reservation.status <- function(id_res) {
  query <- paste0("SELECT status FROM rezerwacja WHERE id_rezerwacja = '", id_res, "'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  rstatus <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(rstatus)
}

load.reservation.payment <- function(id_res) {
  query <- paste0("SELECT czy_oplacona FROM rezerwacja WHERE id_rezerwacja = '", id_res, "'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  payment <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(payment)
}

load.movies <- function() {
  query <- "SELECT tytul FROM grane_filmy"
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  movies <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  titles <- movies$tytul
  return(titles)
}

load.movies.by.title <- function(title) {
  query <- paste0("SELECT * FROM grane_filmy WHERE tytul = '", title, "'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  movies <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(movies)
}

load.screenings.by.date <- function(date) {
  date <- as.character(date)
  query <- paste0("SELECT * 
              FROM aktywne_seanse
              WHERE data = '", date,"'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  screenings <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(screenings)
}

load.screenings.by.title <- function(title) {
  query <- paste0("SELECT *
              FROM aktywne_seanse 
              WHERE tytul ILIKE '", title,"'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  screenings <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(screenings)
}

load.reservation <- function(stat, email) {
  query <- paste0("SELECT id_rezerwacja, tytul, data, godzina, nr_sali, nr_miejsca, nr_rzedu, czy_oplacona, cena
                  FROM widok_rezerwacje
                  WHERE status = '", stat, "' AND mail = '", email ,"'")
  con <- open.my.connection()
  res <- dbSendQuery(con, query)
  reservations <- dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(reservations)
}

add.reservation <- function(id, mail, rzad, miejsce) {
  query <- paste0("SELECT dodaj_rezerwacje_id('",
                  id,"','",mail ,"','",rzad,"','",miejsce,"')")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
}

active.screenings <- function() {
  query <- "SELECT aktualne_seanse();"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
}

set.reservation.by.date <- function(date) {
  query <- paste0("SELECT id_seans FROM aktywne_seanse WHERE data = '", date, "'")
  con = open.my.connection()
  res = dbGetQuery(con,query)
  close.my.connection(con)
  if (nrow(res) > 0) {
    return(as.vector(res$id_seans))
  } else {
    return(character(0))  # Zwraca pusty wektor, gdy brak wyników
  }
}

set.reservation.by.title <- function(title) {
  query <- paste0("SELECT id_seans FROM aktywne_seanse WHERE tytul ILIKE '", title, "'")
  con = open.my.connection()
  res = dbGetQuery(con,query)
  close.my.connection(con)
  if (nrow(res) > 0) {
    return(as.vector(res$id_seans))
  } else {
    return(character(0))
  }
}

add.client <- function(name, sname, mail, passwrd) {
  query <- paste0("INSERT INTO klient(imie, nazwisko, mail, haslo) VALUES ('", name, "','", sname, "','", mail, "','", passwrd, "')")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
}

edit.reservation.by.id <- function(stat, email) {
  query <- paste0("SELECT id_rezerwacja FROM rezerwacja JOIN klient USING(id_klient) WHERE status = '", stat, "' AND mail = '", email, "'")
  con <- open.my.connection()
  res <- dbGetQuery(con, query)
  close.my.connection(con)
  if (nrow(res) > 0) {
    return(as.vector(res$id_rezerwacja))
  } else {
    return(character(0))
  }
}

delete.reservation <- function(id) {
  query <- paste0("DELETE FROM rezerwacja WHERE id_rezerwacja = '", id, "'")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
}

pay.for.reservation <- function(id) {
  query <- paste0("UPDATE rezerwacja SET czy_oplacona = TRUE WHERE id_rezerwacja = '", id, "'")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
}

add.card <- function(email, nr_karty) {
  query <- paste0("UPDATE klient SET nr_karty_czlonkowskiej = '", nr_karty, "' WHERE mail = '", email, "'")
  con = open.my.connection()
  res = dbGetQuery(con,query)
  close.my.connection(con)
}
