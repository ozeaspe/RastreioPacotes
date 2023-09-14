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
    public static void inserirDados(String nomeourazaosocial, String telefone, String qtnPacotes) {
        Account novoDado = new Account();
        
        novoDado.nomeourazao = nomeourazaosocial;
        novoDado.Phone = Phone;
        novoDado.qtnpacotes = qtnpacotes;

        try {
            insert novoDado;
        } catch (Exception e) {
            // Lide com qualquer erro de inserção aqui
            System.debug('Erro ao inserir dado: ' + e.getMessage());
        }
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