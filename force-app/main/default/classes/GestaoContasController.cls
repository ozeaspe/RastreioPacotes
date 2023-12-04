public class GestaoContasController {

    @AuraEnabled
    public static CepModel consultaCep(String cep){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://viacep.com.br/ws/'+cep+'/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
         CepModel results = new CepModel();
        system.debug('results: '+results);
        if (response.getStatusCode() == 200) {            
            results = (CepModel) JSON.deserialize(response.getBody(),CepModel.class);
            system.debug('results');
            system.debug(results);
            system.debug(results.logradouro);
        }                
        
        return results; 

    }



    @AuraEnabled
    public static List <Account> getAccount(String accountType){
        try {

            List<Account> lstAccount = new List<Account>();

            if(accountType == 'CPF'){
                lstAccount = [SELECT Id, 
                                    CPF__c, 
                                    BillingCity, 
                                    BillingPostalCode,
                                    localidade__c, 
                                    BillingState, 
                                    BillingStreet,
                                    qtnPacotes__c, 
                                    Name, 
                                    Phone  
                                FROM Account 
                                WHERE CPF__c != null]; 

            }else{
                 lstAccount = [SELECT Id, 
                                    CNPJ__c, 
                                    BillingCity, 
                                    BillingPostalCode,
                                    localidade__c, 
                                    BillingState, 
                                    BillingStreet,
                                    qtnPacotes__c, 
                                    Name, 
                                    Phone  
                                FROM Account 
                                WHERE CNPJ__c != null];
            

            }
            return lstAccount;

        } 
        
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void inserirDados(String nome, String cpfoucnpj, String telefone, String qtnPacotes, String cep, String rua, String bairro, String cidade, String uf ) {
        Account novoDado = new Account();

         if(cpfoucnpj.length() > 11){
            novoDado.CNPJ__c = cpfoucnpj;
        }else{
            novoDado.CPF__c = cpfoucnpj;
        }

            novoDado.Name = nome;
            novoDado.Phone = telefone;
            novoDado.qtnPacotes__c = qtnPacotes;
            novoDado.BillingPostalCode = cep;
            novoDado.BillingStreet = rua;
            novoDado.BillingStreet = bairro;
            novoDado.localidade__c = cidade;
            novoDado.BillingState = uf;
        
        try {
            insert novoDado;
            
        } catch (Exception e) {
            
            System.debug('Erro ao inserir dado: ' + e.getMessage());
    }
    }

   @AuraEnabled
   public static Map<String, Object> deletarRegistro(String idConta){
       System.debug('### APEX > deletarRegistro');
       Map<String, Object> retorno = New Map<String, Object>();
       try{
           //Por algum motivo o Id da conta está vindo com asplas duplas, entao utilizei o metodo replace para remover
           //Seria uma boa investigar por qual motivo esse id da conta está chegando aqui com aspas duplas
           Account conta = [SELECT Id FROM Account WHERE Id =: idConta.replace('"', '') LIMIT 1];

           Database.DeleteResult result = Database.Delete(conta, false);
           if (result.isSuccess()) {
               retorno.put('success', true);
               retorno.put('msg', 'Conta deletada com sucesso!');
           } else {
               retorno.put('success', false);
               for (Database.Error err : result.getErrors()) {
                   retorno.put('msg', 'Error ao deletar conta: ' + err.getMessage());
               }
           }
       } catch(Exception e){
           retorno.put('success', false);
           retorno.put('msg', 'Back-End Error: ' + e.getMessage() + ' Line: '+ e.getLineNumber());  
       }
        
   	return retorno;
   }
    
    class CepModel {
    
        @AuraEnabled public String cep;
        @AuraEnabled public String logradouro;
        @AuraEnabled public String complemento;
        @AuraEnabled public String bairro;
        @AuraEnabled public String localidade;
        @AuraEnabled public String uf;
        @AuraEnabled public String unidade;
        @AuraEnabled public String ibge;
        @AuraEnabled public String gia;
            
    }

}