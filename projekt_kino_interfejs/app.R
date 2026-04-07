library(shiny)
library(shinythemes)
library(DBI)
library(RPostgres)
library(DT)
library(shinydashboard)

source(file = "C:\\Users\\ameli\\Documents\\projekt_kino\\funkcje.R", echo = TRUE)

ui <- dashboardPage(
  dashboardHeader(
    title = tags$span("Kino OK", 
                      style = "font-family: 'Garamond'; font-size: 24px; color: white;"),
    tags$li(
      class = "dropdown",
      style = "padding: 10px;",
      actionButton(
        inputId = "refresh_button",
        label = "Odśwież",
        icon = icon("refresh"),
        style = "color: white; background-color: pink; border: none; font-family: 'Garamond';"
      )
    )
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Seanse", tabName = "seanse", icon = icon("ticket")),
      menuItem("Informacje o filmach", tabName = "filmy", icon = icon("film")),
      menuItem("Rezerwacje", tabName = "rezerwacje", icon = icon("calendar-check")),
      menuItem("Informacje o kliencie", tabName = "klienci", icon = icon("user"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .main-header {
          color: black !important;
          background-color: pink !important;
        }
        .main-header .logo {
          background-color: pink !important;
        }
        .main-header .navbar {
          background-color: pink !important;
        }
        
        h1, h2, h3, .box-title, .navbar-text {
          text-shadow: 2px 2px 5px black;
          color: yellow;
          font-family: 'Garamond';
        }
        
        h4 a {
          color: black;
        }
        
        .sidebar-menu a {
          color: white !important;
          text-shadow: 2px 2px 5px yellow;
        }
      "))
    ),
    
    # Zakładki aplikacji
    tabItems(
      # Zakładka Seanse
      tabItem(tabName = "seanse",
              h2("Seanse filmowe"),
              p("Tutaj dostępne są informacje o zaplanowanych seansach oraz nadchodzących premierach."),
              
              fluidRow(
                column(6,
                       textInput("filter_title", 
                                 label = "Wpisz tytuł filmu:", 
                                 placeholder = "Podaj tytuł")
                ),
                column(6,
                       dateInput("filter_date", 
                                 label = "Wybierz datę seansu:", 
                                 value = Sys.Date(),
                                 format = "yyyy-mm-dd")
                )
              ),
              
              fluidRow(
                column(6,
                       actionButton("search_title", "Szukaj")
                )
              ),
              
              fluidRow(
                column(12,
                       DTOutput("screenings_table"),
                       uiOutput("reservation_choice"),
                       uiOutput("reservation_screen"),
                       textOutput("rezerwacja_komunikat")
                       
                       
                )
              )
      ),
      
      # Zakładka Informacje o filmach
      tabItem(tabName = "filmy", 
              h2("Informacje o filmach"), 
              p("Tutaj dostępne są informacje na temat wyświetlanych filmów."),
              fluidRow(
                column(6,
                       selectInput("sel_film",
                                   label = "Wybierz film:",
                                   choices = load.movies())
                )
              ),
              
              fluidRow(
                column(4,
                       actionButton("szukaj_filmu", "Szukaj")
                )
              ),
              
              fluidRow(
                column(12, 
                       DTOutput("filmy_tabela")
                )
              )
      ),
      
      # Zakładka Rezerwacje
      tabItem(tabName = "rezerwacje",
              h2("Rezerwacje"),
              p("Tutaj dostępne są informacje o twoich rezerwacjach. Pamiętaj, że jeśli zdecydujesz się na opłacenie rezerwacji to nie będziesz mógł jej usunąć!"),
              fluidRow(
                column(4,
                       selectInput("sel_res", 
                                   label = "Filtruj rezerwacje:", 
                                   choices = c("Aktywne" = "aktywna", "Nieaktywne" = "nieaktywna"),
                                   selected = "aktywne")
                ),
                
                column(4,
                       textInput("txt_res",
                                 label = "Wpisz e-mail:",
                                 placeholder = "example@mail.com")
                )
              ),
              
              fluidRow(
                column(2,
                       actionButton("search_reservations", "Szukaj")
                )
              ),
              
              fluidRow(
                column(12,
                       DTOutput("reservations_table")
                )
              ),
              
              fluidRow(
                column(12,
                       DTOutput("reservations_table"),
                       uiOutput("reservation_edit"),
                       uiOutput("reservation_edit2")
                )
              )
      ),
      
      # Zakładka Informacje o kliencie
      tabItem(tabName = "klienci",
              h2("Informacje o kliencie"),
              p("Tutaj uzyskasz dostęp do informacji o swoim profilu klienta oraz o aktualnych zniżkach."),
              
              fluidRow(
                column(5,
                       align = "left",
                       textInput("info_mail",
                                 label = "Wpisz swój e-mail, aby uzyskać informacje o swoim profilu klienta:",
                                 placeholder = "example@mail.com")
                ),
                
                column(2,
                       h4("LUB"),
                       align = "center"
                ),
                
                column(5,
                       align = "left",
                       textInput("new_name",
                                 label = "Nie masz konta? Dodaj swoje dane do bazy klientów! :)", 
                                 placeholder = "Imię")
                )
              ),
              
              fluidRow(
                column(5,
                       passwordInput("info_password",
                                 label = NULL,
                                 placeholder = "Hasło")
                ),
                
                column(2,
                       text = " "),
                
                column(5,
                       textInput("new_surname",
                                 label = NULL,
                                 placeholder = "Nazwisko")
                )
              ),
              
              fluidRow(
                column(5,
                       actionButton("log_in", "Zaloguj")
                ),
                
                column(2, 
                       text = " "),
                
                column(5,
                       textInput("new_mail",
                                 label = NULL,
                                 placeholder = "example@mail.com")
                )
              ),
              
              fluidRow(
                column(7,
                       text = " "),
                
                column(5,
                       passwordInput("new_password",
                                 label = NULL,
                                 placeholder = "Utwórz hasło (min. 8 znakow)")
                )
              ),
              
              fluidRow(
                column(7, 
                       text = " "),
                
                column(5,
                       passwordInput("repeat_password",
                                 label = NULL,
                                 placeholder = "Powtórz hasło")
                )
              ),
              
              fluidRow(
                column(7, 
                       text = " "),
                
                column(5,
                       actionButton("sign_in", "Utwórz konto")
                )
              ),
              
              fluidRow(
                column(12,
                       DTOutput("client_info"),
                       uiOutput("new_card")
                )
              )
      )
    )
  )
)




# Serwer
server <- function(input, output, session) {
  
  observeEvent(input$refresh_button, {
    active.screenings()
  })
  
  observeEvent(input$filter_date, {
    screenings_data <- load.screenings.by.date(input$filter_date)
    
    output$reservation_choice <- renderUI({
      fluidRow(
        column(6,
               selectInput(
                 "wybierz_rezerwacje", 
                 label = "Zarezerwuj miejsce:", 
                 choices = c("Wybierz seans", as.vector(set.reservation.by.date(input$filter_date))),
                 selected = "Wybierz seans"
               ))
      )
    })
    
    output$screenings_table <- renderDT({
      datatable(
        screenings_data,
        options = list(pageLength = 10, lengthChange = FALSE, searching = TRUE),
        rownames = FALSE, colnames = c("ID seansu", "Tytuł", "Data", "Godzina", "Dźwięk", "Grafika", "Mail pracownika")
      )
    })
  })
  
  observeEvent(input$search_title, {
    screenings_data_t <- load.screenings.by.title(input$filter_title)
    
    output$reservation_choice <- renderUI({
      fluidRow(
        column(6,
               selectInput(
                 "wybierz_rezerwacje", 
                 label = "Zarezerwuj miejsce:", 
                 choices = c("Wybierz seans", as.vector(set.reservation.by.title(input$filter_title))),
                 selected = "Wybierz seans"
               ))
      )
    })
    
    output$screenings_table <- renderDT({
      datatable(
        screenings_data_t,
        options = list(pageLength = 10, lengthChange = FALSE, searching = FALSE),
        rownames = FALSE, colnames = c("ID seansu", "Tytuł", "Data", "Godzina", "Dźwięk", "Grafika", "Mail pracownika")
      )
    })
  })
  
  observeEvent(input$wybierz_rezerwacje, {
    
    output$reservation_screen <- renderUI({
      validate(
        need(input$wybierz_rezerwacje != "Wybierz seans", "Wybór seansu jest wymagany!")  
      )
      
      
      fluidRow(
        column(8,
               img(src = "sala_kina.png", width = 400)
        ),
        column(4,
               selectInput(
                 "wolne_miejsca",
                 label = "Wybierz miejsce",
                 choice = c("Wolne miejsca", load.free.seats(input$wybierz_rezerwacje)),
                 selected = "Wolne miejsca"
               ),
               textInput("email_do_rezerwacji",
                         label = "Podaj adres e-mail:",
                         placeholder = "example@mail.com"
               ),
               actionButton("dodaj_rezerwacje",
                            "Dodaj rezerwację")
        )
      )
    })
  })
  
  observeEvent(input$dodaj_rezerwacje, {
    miejsce_info <- strsplit(input$wolne_miejsca, ",")[[1]]
    miejsce <- as.integer(trimws(gsub("Miejsce: ", "", miejsce_info[1])))
    rzad <- as.integer(trimws(gsub("Rząd: ", "", miejsce_info[2])))
    wybierz_rezerwacje <- as.integer(input$wybierz_rezerwacje)
    
    tryCatch({
      add.reservation(wybierz_rezerwacje, input$email_do_rezerwacji, rzad, miejsce)
      
      showNotification("Rezerwacja została dodana!", type = "message")
    }, error = function(e) {
      showNotification(paste("Błąd:", e$message), type = "error")
    })
  })
  
  observeEvent(input$search_reservations, {
    reservations <- load.reservation(input$sel_res, input$txt_res)
    
    output$reservations_table <- renderDT({
      datatable(
        reservations,
        options = list(pageLength = 10, lengthChange = FALSE, searching = FALSE),
        rownames = FALSE, colnames = c("ID rezerwacji", "Tytuł", "Data", "Godzina", "Nr sali", "Nr miejsca", "Nr rzędu", "Czy opłacona", "Cena")
      )
    })
    
    output$reservation_edit <- renderUI({
      fluidRow(
        column(6,
               selectInput(
                 "zmien_rezerwacje", 
                 label = "Edycja rezerwacji:", 
                 choices = c("ID rezerwacji", as.vector(edit.reservation.by.id(input$sel_res, input$txt_res))),
                 selected = "ID rezerwacji"
               ))
      )
    })
  })
  
  observeEvent(input$zmien_rezerwacje, {
    
    output$reservation_edit2 <- renderUI({
      validate(
        need(input$zmien_rezerwacje != "ID rezerwacji", "Wpisz ID rezerwacji, aby opłacać lub usuwać rezerwacje!")  
      )
      
      
      fluidRow(
        column(5, 
               align = "center",
               actionButton("oplac_rezerwacje", "Opłać rezerwację")
        ),
        column(2,
               align = "center",
               h4("LUB")
        ),
        column(5,
               align = "center",
               actionButton("usun_rezerwacje", "Usuń rezerwację"))
      )
    })
  })
  
  observeEvent(input$oplac_rezerwacje, {
    tryCatch({
      if (load.reservation.status(input$zmien_rezerwacje)$status == 'nieaktywna' & load.screening.status(input$zmien_rezerwacje)$status == 'nieaktywny') {
        showNotification("Błąd: Nie mozesz oplacic rezerwacji seansów, ktore juz sie odbyły", type = "error")
      }
      else if (load.reservation.payment(input$zmien_rezerwacje)$czy_oplacona == TRUE) {
        showNotification("Błąd: Nie możesz opłacić rezerwacji drugi raz (chociaż bardzo byśmy chcieli ;))", type = "error")
      }
      else {
        pay.for.reservation(input$zmien_rezerwacje)
        
        
        showNotification("Rezerwacja została opłacona!", type = "message")
      }
    }, error = function(e) {
      showNotification(paste("Błąd:", e$message), type = "error")
    })
  })
  
  observeEvent(input$usun_rezerwacje, {
    tryCatch({
      if (load.reservation.payment(input$zmien_rezerwacje) == TRUE) {
        showNotification("Błąd: Rezerwacja została już opłacona i nie może zostać usunięta!", type = "error")
      }
      else {
        delete.reservation(input$zmien_rezerwacje)
        
        
        showNotification("Rezerwacja została usunięta!", type = "message")
      }
    }, error = function(e) {
      showNotification(paste("Błąd:", e$message), type = "error")
    })
  })
  
  observeEvent(input$szukaj_filmu, {
    films <- load.movies.by.title(input$sel_film)
    
    output$filmy_tabela <- renderDT({
      datatable(
        films,
        options = list(pageLength = 10, lengthChange = FALSE, searching = FALSE),
        rownames = FALSE, colnames = c("Tytuł", "Oryginalny Tytuł", "Opis", "Długość", "Kraj produkcji", "Data premiery", "Ograniczenia wiekowe", "Gatunek")
      )
    })
  }) 
  
  observeEvent(input$log_in, {
    clients <- load.clients(input$info_mail, input$info_password)
    
    if(nrow(clients) == 0) {
      showNotification(paste("Niepoprawne hasło lub mail. Spróbuj ponownie."), duration = 10, type = "error")
      return()}
    
    output$client_info <- renderDT({
      datatable(
        clients,
        options = list(pageLength = 10, lengthChange = FALSE, searching = FALSE),
        rownames = FALSE, colnames = c("Imię", "Nazwisko", "E-mail", "Nr karty członkowskiej")
      )
    })
    
    output$new_card <- renderUI({
      fluidRow(
        column(4,
               textInput("card_nr",
                         label = "Dodaj kartę członkowską:",
                         placeholder = "Nr karty członkowskiej")
               ),
        
      fluidRow(
        column(2,
               actionButton("add_card",
                            label = "Dodaj")
               )
      )
        
      )
    })
  })
  
  observeEvent(input$add_card, {
    
    tryCatch({
      add.card(input$info_mail, input$card_nr)
      
      showNotification("Karta została dodana!", type = "message")
    }, error = function(e) {
      showNotification(paste("Błąd:", e$message), type = "error")
    })
  })
  
  observeEvent(input$sign_in, {
    if (input$new_name == "" || input$new_surname == "") {
      showNotification("Imię i nazwisko nie mogą być puste.", duration = 7, type = "error")
      return()
    }
    
    if (input$new_password == "") {
      showNotification("Hasło nie może być puste", duration = 7, type = "error")
      return()
    }
    
    if (!grepl("^\\S+@\\S+\\.\\S+$", input$new_mail)) {
      showNotification(paste("Niepoprawny format adresu e-mail. Spróbuj ponownie."), duration = 7, type = "error")
      return()
    }
    
    passwrd <- load.password(input$new_mail)
    clients <- load.clients(input$new_mail, passwrd)
    
    if (nrow(clients) != 0) {
      showNotification(paste("Użytkownik o tym mailu już istnieje."), duration = 7, type = "error")
      return()
    }
    
    if (input$new_password != input$repeat_password) {
      showNotification(paste("Hasła nie są takie same."), duration = 7, type = "error")
      return()
    }
    
    tryCatch({
      add.client(input$new_name, input$new_surname, input$new_mail, input$new_password)
      showNotification("Rejestracja zakończona sukcesem!", duration = 7, type = "message")
    }, error = function(e) {
      showNotification(paste("Wystąpił błąd podczas rejestracji:", e$message), duration = 7, type = "error")
    })
  })
  
}

# Uruchomienie aplikacji
shinyApp(ui = ui, server = server)
