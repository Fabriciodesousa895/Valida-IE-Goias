CREATE OR REPLACE NONEDITIONABLE FUNCTION VAL_IE_GO(P_IE VARCHAR)
RETURN VARCHAR
IS
 V_IE VARCHAR(20);
 V_COUNT INT;
 V_COUNT_2 INT;
 V_RESULT VARCHAR(100); 
BEGIN
  --REMOVENDO CARACTERES ESPECIAIS;
     V_IE := REGEXP_REPLACE(P_IE,'[^a-zA-Z0-9\s]','');
     --VERIFICANDO SE HÁ LETRAS;
     SELECT COUNT(*) INTO V_COUNT FROM DUAL WHERE REGEXP_LIKE(V_IE,'[A-Za-z]');
     
     IF V_COUNT > 0 THEN
       RAISE_APPLICATION_ERROR(-20203,'A IE informada não é válida,não é permitido letras e nem caracteres especais!');
     END IF;
     
     IF V_COUNT = 0 THEN
       --VALIDANDO A QUANTIDADE DE DIGITOS;
       IF LENGTH(V_IE) = 9 THEN
         --VALIDANDO OS 2 PRIMEIROS DIGITOS QUE DEVEM SER UM DOS TRÊS NUMEROS (10,11,20,29);
         IF SUBSTR(V_IE,1,2)  IN (10,11,20,29) THEN
           
               V_COUNT_2 := MOD(  SUBSTR(V_IE,1,1) * 9 +
                              SUBSTR(V_IE,2,1) * 8 +
                              SUBSTR(V_IE,3,1) * 7 +
                              SUBSTR(V_IE,4,1) * 6 +
                              SUBSTR(V_IE,5,1) * 5 +
                              SUBSTR(V_IE,6,1) * 4 +
                              SUBSTR(V_IE,7,1) * 3 +
                              SUBSTR(V_IE,8,1) * 2 ,11) ;
           --SE O RESTO DA DIVISAO FOR 0 OU 1 E O DIGITO VERIFICADOR FOR 0 A IE É VÁLIDA
           IF V_COUNT_2 IN (0,1) AND SUBSTR(V_IE,9,1) = 0 THEN
                        V_RESULT := 'A IE ' || V_IE  ||' é verdadeira.';
                        ELSE
                                       --SE OS RESTO DA DIVISAO FOR DIFERENTE DE 1 OU 0 O DIGITO VERIFICADOR DEVE SER IGUAL A  11 MENOS O RESTO DA DIVISÃO;
                                         IF V_COUNT_2 NOT IN (0,1) AND 11 - V_COUNT_2 =  SUBSTR(V_IE,9,1) THEN
                                                      V_RESULT := 'A IE ' || V_IE  || ' é verdadeira.';
                                         ELSE
                                                      V_RESULT := 'A IE ' || V_IE || ' não é válida!';
                                         END IF;
           END IF;

           
         ELSE
           RAISE_APPLICATION_ERROR(-20204,'IE não é válida,os dois primeiros digitos devem ser um dos numeros a seguir => 10,11,20,29');
         END IF;
       ELSE
         RAISE_APPLICATION_ERROR(-20205,'IE deve ter 9 digitos!');
       END IF;
     END IF;
     
     RETURN V_RESULT;
END;
