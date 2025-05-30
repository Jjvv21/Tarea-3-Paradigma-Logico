:- consult('BaseDeDatos.pl').

/* Lista de Verbos */
verbo--> [].
verbo--> [dirijo];[diriges];[dirige];[dirigimos];[dirigen].
verbo--> [dirigire];[dirigiras];[dirigira];[digiremos];[dirigiran];[dirigirnos].
verbo--> [desplazo];[desplazas];[desplaza];[desplazamos];[desplazan].
verbo--> [desplazare];[desplazaras];[desplazara];[desplazaremos].
verbo--> [estoy];[estas];[esta];[estamos];[estan].
verbo--> [estare];[estaras];[estara];[estaremos];[estaran];[estado].
verbo--> [encuentro];[encuentras];[encuentra];[encontramos];[encuentran].
verbo--> [gusta];[gustaria];[gustan];[gustarian].
verbo--> [voy];[vas];[va];[vamos];[van].
verbo--> [ire];[iras];[ira];[iremos];[iran].
verbo--> [llego];[lelgas];[llega];[llegamos];[llegan].
verbo--> [llegare];[llegaras];[llegara];[llegaremos];[llegaran].
verbo--> [muevo];[mueves];[mueve];[movemos];[mueven].
verbo--> [movere];[moveras];[movera];[moveremos];[moveran].
verbo--> [necesito];[necesitas];[necesita];[necesitamos];[necesitan].
verbo--> [necesitare];[necesitaras];[necesitara];[necesitaremos];[necesitaran].
verbo--> [ocupo];[ocupas];[ocupa];[ocupamos];[ocupan].
verbo--> [ocupare];[ocuparas];[ocupara];[ocuparemos];[ocuparan].
verbo--> [quiero];[queres];[quiere];[queremos];[quieren].
verbo--> [querra];[querras];[querra];[querremos];[querran].
verbo--> [salgo];[salis];[sale];[salimos];[salen].
verbo--> [saldre];[saldria];[saldra];[saldremos];[saldran].
verbo--> [tengo];[tenes];[tiene];[tenemos];[tienen].
verbo--> [tendre];[tendras];[tendra];[tendremos];[tendran].
verbo--> [vengo];[vienes];[viene];[venimos];[venis];[venimos];[vienen].
verbo--> [vendre];[vendras];[vendran];[vendra];[vendremos].
verbo--> [viajo];[viajas];[viaja];[viajamos];[viajan].
verbo--> [viajare];[viajaras];[viajara];[viajaremos];[viajaran].
verbo--> [vuelvo];[vuelvas];[vuelve];[volvemos];[vuelven].
verbo--> [volvere];[volverias];[volvera];[volveremos];[volveran].

/*Verbos infinitivos*/
infinitivo-->[].
infinitivo-->[dirigir];[desplazar];[estar];[encontrar];[gustar];[ir];[llegar].
infinitivo-->[mover];[necesitar];[ocupar];[querer];[salir].
infinitivo-->[tener];[venir];[viajar];[volver].

/*Pronombres personales*/
pronombre-->[].
pronombre-->[yo];[tu];[vos];[usted];[nosotros];[nosotras];[ellos];[ellas];[ustedes];[el];[ella].
pronombre-->[me];[mi];[te];[ti];[si];[se];[nos].

/*Preposiciones mas usadas*/
preposicion-->[];[a];[al];[ante];[bajo];[con];[contra];[de];[del];[desde];[en];[entre];[hacia];[hasta].
preposicion-->[durante];[mediante];[para];[por];[pro];[sin];[so];[segun];[sobre];[tras];[versus];[via].

/*Articulos*/
articulo-->[].
articulo-->[el];[lo];[un];[unos].
articulo-->[la];[las];[una];[unas].
articulo-->[al];[del].

/*Posibles sustantivos dentro de desplazamientos*/
sustantivos-->[];[destino];[avion];[origen];[aerolinea];[clase];[presupuesto];[lugar];[pais];[ciudad];[dolares];[viaje];[vacaciones];[actividad];[navidad];[barato];[vuelo].

/*Adverbios: funcionan para respuetas concretas*/
adverbio-->[];[si];[no];[ninguno];[ninguna];[tambien];[claro];[mas].

/*Adjetivos: En caso de varios pasos*/
adjetivo--> [];[primero];[luego];[barato].

/*Conjunciones*/
conjuncion-->[];[que].

/*Signos de puntuacion*/
simbolos-->[];['.'];[',']; [';'].

/*Sintagmas utilizados en una oracion*/
sintagma_nominal-->[].
sintagma_nominal --> pronombre.
sintagma_nominal --> preposicion,simbolos, articulo, simbolos.
sintagma_nominal --> preposicion,simbolos,sustantivos.
sintagma_nominal --> preposicion,simbolos, articulo,simbolos, preposicion,simbolos,palabra(_),sintagma_nominal.

sintagma_verbal --> adverbio,simbolos, pronombre ,simbolos, adjetivo,simbolos, sustantivos,simbolos, verbo, simbolos, conjuncion, simbolos, preposicion, simbolos, infinitivo,simbolos, conjuncion, simbolos, sintagma_nominal.

% Opción 1: una sola palabra
palabra(X) -->
    [A],
    { esInfo(A), X = A }.

% Opción 2: dos palabras unidas con '_'
palabra(X) -->
    [A, B],
    { atomic_list_concat([A, B], '_', Nombre),
      esInfo(Nombre),
      X = Nombre }.

% Opción 3: dos palabras unidas con '_'
palabra(X) -->
    [A, B, C],
    { atomic_list_concat([A, B, C], '_', Nombre),
      esInfo(Nombre),
      X = Nombre }.


/* Verifica si la palabra pertenece a la base de datos*/
esInfo(X):- es_aerolinea(X);es_clase(X);es_lugar(X);integer(X);esBalatro(X).

/*Verifica que todas las palabras dentro de la oracion sean validas.
  Puede ser una oracion completa, o solo un si, no, ninguno etc.*/
oracion --> sintagma_nominal, sintagma_verbal.
oracion --> adverbio.

oraciones_restantes([], []).  % Caso base: éxito

oraciones_restantes(Palabras, RestoFinal) :-
    buscar_oracion(Palabras, Oracion, Resto),
    phrase(oracion, Oracion),
    (oraciones_restantes(Resto, RestoFinal)->!;(!,fail)).

oraciones_restantes(_, _) :-
    fail.  % Falla si no encontró una oración válida

buscar_oracion(Palabras, Oracion, Resto) :-
    length(Palabras, L),
    between(1, L, N),        % intenta oraciones de longitud 1 a L
    length(Oracion, N),
    append(Oracion, Resto, Palabras),
    phrase(oracion, Oracion),
    Resto \= Palabras, !.    % una vez que encuentra una, se detiene



% Caso base
extraerInfo([], _, [], _).

% Caso 1: palabra válida, clasificada, y no duplicada
extraerInfo(Frase, Anterior, [Dato | RestoInfo], Acumulado) :-
    palabra(Palabra, Frase, RestoFrase),
    clasificarInfo(Anterior, Palabra, Dato),
    \+ ya_existe(Dato, Acumulado),
    extraerInfo(RestoFrase, Palabra, RestoInfo, [Dato | Acumulado]).

% Caso 2: palabra válida, pero clasificada y duplicada → se ignora
extraerInfo(Frase, Anterior, RestoInfo, Acumulado) :-
    palabra(Palabra, Frase, RestoFrase),
    clasificarInfo(Anterior, Palabra, Dato),
    ya_existe(Dato, Acumulado),
    extraerInfo(RestoFrase, Palabra, RestoInfo, Acumulado).

% Caso 3: número válido, clasificado y no duplicado
extraerInfo([PalabraActual | Resto], _, [Dato | RestoInfo], Acumulado) :-
    integer(PalabraActual),
    clasificarInfo(_, PalabraActual, Dato),
    \+ ya_existe(Dato, Acumulado),
    extraerInfo(Resto, PalabraActual, RestoInfo, [Dato | Acumulado]).

% Caso 4: número duplicado → se ignora
extraerInfo([PalabraActual | Resto], _, RestoInfo, Acumulado) :-
    integer(PalabraActual),
    clasificarInfo(_, PalabraActual, Dato),
    ya_existe(Dato, Acumulado),
    extraerInfo(Resto, PalabraActual, RestoInfo, Acumulado).

% Caso 5: palabra inválida → avanzar
extraerInfo([PalabraActual | Resto], _, Info, Acumulado) :-
    \+ phrase(palabra(_), [PalabraActual | Resto]),
    \+ integer(PalabraActual),
    extraerInfo(Resto, PalabraActual, Info, Acumulado).


ya_existe(destino(X), Lista)    :- member(destino(_), Lista);  member(origen(X), Lista).     % No permitir si ya es origen
ya_existe(origen(X), Lista)     :- member(origen(_), Lista);member(destino(X), Lista).    % No permitir si ya es destino
ya_existe(clase(_), Lista)      :- member(clase(_), Lista).
ya_existe(aerolinea(_), Lista)  :- member(aerolinea(_), Lista).
ya_existe(presupuesto(_), Lista):- member(presupuesto(_), Lista).

clasificarInfo(desde, X, origen(X)) :- es_lugar(X).
clasificarInfo(de, X, origen(X)) :- es_lugar(X).
clasificarInfo(en, X, origen(X)) :- es_lugar(X).
clasificarInfo(a, X, destino(X)) :- es_lugar(X).
clasificarInfo(hasta, X, destino(X)) :- es_lugar(X).
clasificarInfo(hacia, X, destino(X)) :- es_lugar(X).
clasificarInfo(_, X, origen(X)):- es_lugar(X).
clasificarInfo(_, X, destino(X)):- es_lugar(X).
clasificarInfo(_, X, clase(X)) :- es_clase(X).
clasificarInfo(_, X, aerolinea(X)) :- es_aerolinea(X).
clasificarInfo(_, X, presupuesto(X)):- integer(X).
clasificarInfo(_, X, barato(X)):- esBalatro(X).















