
'Predkosc taktowania
$crystal = 3579545
Config Lcd = 24 * 2
'Przypisanie zmiennych do portow
Odb1 Alias P3.6
Odb2 Alias P3.7
'Zatrzaski matrycy A i C
Ae_a Alias P5.7
Ae_c Alias P6.7

'Deklaracja zmiennych
Dim Stan_obecny As Byte
Dim Stan_poprzedni As Byte
Dim Stan_odb As Byte
Dim Num_ab As Byte
Dim Odb1_service As Byte
Dim Odb2_service As Byte
Dim Licznik As Byte
Dim Ile_zajetych_odb As Byte
Dim Kolejka_1 As Byte
Dim Kolejka_2 As Byte
Dim X As Byte

'Wartosci poczatkowe zmiennych
Stan_poprzedni = 0
Licznik = 0
Ile_zajetych_odb = 0
Odb1_service = 8
Odb2_service = 8
Kolejka_1 = 0
Kolejka_2 = 0
X = 0

'Zerowanie stanow na portach
P0 = &H00
P1 = &H00
P2 = &H00
P3 = &H00
P4 = &H00
P5 = &H00
P6 = &H00

'Glowna petla
Do
   Stan_odb = P3 And &B11000000
   Stan_obecny = P4 And &B00111111
   Ae_a = 0
   Ae_c = 0

   'Nowe polaczenie
   'Jesli jest spelniony warunek to pojawia sie nowy ab
   If Stan_obecny > Stan_poprzedni Then
       'Print "Abonent do��cza do obs�ugi"
       P0 = Stan_obecny - Stan_poprzedni
    'Okreslenie ktory abonent dolaczyl do obslugi
       For Licznik = 0 To 5
          If P0.licznik = 1 Then
             Num_ab = Licznik
          End If
       Next Licznik

   'Oba odb zajete
   If Stan_odb = &B11000000 Then
      Print "Odb1 oraz Odb2 s� zajete"
      If Kolejka_1 = 0 Then
        Kolejka_1 = Num_ab + 1
        Print "Ab nr" ; Num_ab ; " zostal dodany do kolejki"
      Elseif Kolejka_2 = 0 Then
         Kolejka_2 = Num_ab + 1
         Print "Ab nr" ; Num_ab ; " zostal dodany do kolejki"
      Else
         P4.num_ab = 0
         Print "Kolejka pelna, polaczenie odrzucone"
   'Powrot do stanu poprzedniego
         Stan_obecny = Stan_obecny - P0
      End If

   End If

   'Odbiornik1 wolny, Odbiornik2 zajety
   If Stan_odb = &B10000000 Then
   Odb1:
   Print "Ab nr" ; Num_ab ; " nawiazal polaczenie"
      Print "Odb1 obsluguje ab nr" ; Num_ab
      Odb1_service = Num_ab
      'zapisanie numeru abonenta binarnie na liniach A2, A1, A0 matrycy A
      P5 = Num_ab * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P5 = P5 + 1
      'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
      Ae_a = 1
      Ae_a = 0
      'zapisanie numeru odbiornika binarnie na liniach A2, A1, A0 matrycy C
      P6 = 6 * 16
      P6 = P6 + 1
      'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
      Ae_c = 1
      Ae_c = 0

      'zapisanie numeru odbiornika binarnie na liniach A2, A1, A0 matrycy A
      P5 = 6 * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P5 = P5 + 2
      'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
      Ae_a = 1
      Ae_a = 0
      'zapisanie numeru abonenta binarnie na liniach A2, A1, A0 matrycy C
      P6 = Num_ab * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P6 = P6 + 2
      'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
      Ae_c = 1
      Ae_c = 0

      Odb1 = 1
      Ile_zajetych_odb = 2
   End If

   'Odbiornik1 zajety, Odbiornik2 wolny
   If Stan_odb = &B01000000 Then
   Odb2:
      Print "Ab nr" ; Num_ab ; " nawiazal polaczenie"
      Print "Odb2 obsluguje ab nr" ; Num_ab
      Odb2_service = Num_ab
      'zapisanie numeru abonenta binarnie na liniach A2, A1, A0 matrycy A
      P5 = Num_ab * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P5 = P5 + 4
      'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
      Ae_a = 1
      Ae_a = 0
      'zapisanie numeru odbiornika binarnie na liniach A2, A1, A0 matrycy C
      P6 = 7 * 16
      P6 = P6 + 4
      'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
      Ae_c = 1
      Ae_c = 0

      'zapisanie numeru odbiornika binarnie na liniach A2, A1, A0 matrycy A
      P5 = 7 * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P5 = P5 + 8
      'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
      Ae_a = 1
      Ae_a = 0
      'zapisanie numeru abonenta binarnie na liniach A2, A1, A0 matrycy C
      P6 = Num_ab * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P6 = P6 + 8
      'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
      Ae_c = 1
      Ae_c = 0

      Odb2 = 1
      Ile_zajetych_odb = 2
   End If
   'Oba odbiorniki wolne, przyjecie obslugi przez Odb1
   If Stan_odb = &B00000000 Then
      Print "Oba odb sa wolne."
   Print "Ab nr" ; Num_ab ; " nawiazal polaczenie"
      Print "Odb1 obsluguje ab nr" ; Num_ab
      Odb1_service = Num_ab
      'zapisanie numeru abonenta binarnie na liniach A2, A1, A0 matrycy A
      P5 = Num_ab * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P5 = P5 + 1
      'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
      Ae_a = 1
      Ae_a = 0
      'zapisanie numeru odbiornika binarnie na liniach A2, A1, A0 matrycy C
      P6 = 6 * 16
      P6 = P6 + 1
      'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
      Ae_c = 1
      Ae_c = 0

      'zapisanie numeru odbiornika binarnie na liniach A2, A1, A0 matrycy A
      P5 = 6 * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P5 = P5 + 2
      'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
      Ae_a = 1
      Ae_a = 0
      'zapisanie numeru abonenta binarnie na liniach A2, A1, A0 matrycy C
      P6 = Num_ab * 16
      'zapisanie na liniach D3, D2, D1, D0 linii magistrali laczacej matryce A i C
      P6 = P6 + 2
      'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
      Ae_c = 1
      Ae_c = 0
                                                      'aby mozna bylo bezposrednio sterowac przez D
      Odb1 = 1
                                                      'stan zapamietany
      Ile_zajetych_odb = 2
   End If
  End If

   'Sprawdzenie, czy abonent si� roz��czy�
   If Stan_obecny < Stan_poprzedni Then
      P0 = Stan_poprzedni - Stan_obecny
      'Okreslenie ktory ab zostal rozlaczony
   For Licznik = 0 To 5
         If P0.licznik = 1 Then
            Num_ab = Licznik
         End If
      Next Licznik
      X = Num_ab + 1
      Print "Ab nr" ; Num_ab ; " rozlaczyl sie"
      'Rozlaczenie Odb1
      If Odb1_service = Num_ab Then
         Print "Odb1 wolny"
         P5 = Num_ab * 16
         'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
         Ae_a = 1
         P6 = 6 * 16
         Ae_a = 0
         'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
         Ae_c = 1
         Ae_c = 0
         Odb1 = 0
         Odb1_service = 8
         If Ile_zajetych_odb = 2 Then
            Ile_zajetych_odb = 1
         Elseif Ile_zajetych_odb = 1 Then
            Ile_zajetych_odb = 0
         End If
         'Pobranie kolejnego numeru abonenta z kolejki
   If Kolejka_1 > 0 Then
            Num_ab = Kolejka_1 - 1
            Kolejka_1 = Kolejka_2
            Kolejka_2 = 0
            Stan_poprzedni = Stan_obecny
            Goto Odb1
         End If
         P6 = &H00
         P5 = &H00
         'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
         Ae_a = 1
         Ae_a = 0
         'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
         Ae_c = 1
         Ae_c = 0
         'Rozlaczenie Odb2
      Elseif Odb2_service = Num_ab Then


   Print "Odb2 wolny"
         P6 = Num_ab * 16
         'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
         Ae_a = 1
         P6 = 7 * 16
         Ae_a = 0
         'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
         Ae_c = 1
         Ae_c = 0
         Odb2 = 0
         Odb2_service = 8
         If Ile_zajetych_odb = 2 Then
            Ile_zajetych_odb = 1
         Elseif Ile_zajetych_odb = 1 Then
            Ile_zajetych_odb = 0
         End If
         'Pobranie kolejnego numeru abonenta z kolejki
  If Kolejka_1 > 0 Then
            Num_ab = Kolejka_1 - 1
            Kolejka_1 = Kolejka_2
            Kolejka_2 = 0
            Stan_poprzedni = Stan_obecny
            Goto Odb2
         End If
         P6 = &H00
         P5 = &H00
         'ustanowienie stanu wysokiego na zatrzasku matrycy A pozwalajacego na zapisanie stanu matrycy A
         Ae_a = 1
         Ae_a = 0
         'ustanowienie stanu wysokiego na zatrzasku matrycy C pozwalajacego na zapisanie stanu matrycy C
         Ae_c = 1
         Ae_c = 0
      'Przesuniecie numeru abonenta w kolejce
   Elseif Kolejka_1 = X Then
         Kolejka_1 = Kolejka_2
         Kolejka_2 = 0
      Elseif Kolejka_2 = X Then
         Kolejka_2 = 0
      End If


     End If

     Stan_poprzedni = Stan_obecny
     P1 = &H00
     P0 = &H00

Loop
Return