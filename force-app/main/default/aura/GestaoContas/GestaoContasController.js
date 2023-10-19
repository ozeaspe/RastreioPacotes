({
    init: function (component, event, helper) {

        var actions = [
            { label: 'Adicionar', name: 'adicionar' },
            { label: 'Deletar', name: 'deletar' }
        ];

        component.set('v.columns', [
            { label: 'Nome/Razão Social', fieldName: 'nome', type: 'text' },
            { label: 'CPF/CNPJ', fieldName: 'cpfcnpj', type: 'text' },
            { label: 'CEP', fieldName: 'cep', type: 'text' },
            { label: 'Rua', fieldName: 'rua', type: 'text' },
            { label: 'Bairro', fieldName: 'bairro', type: 'text' },
            { label: 'Cidade', fieldName: 'localidade', type: 'text' },
            { label: 'UF', fieldName: 'uf', type: 'text' },
            { label: 'Telefone', fieldName: 'telefone', type: 'phone' },
            { label: 'Quantidade de Pacotes', fieldName: 'qtnPacotes', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);

        helper.getAccountHelper(component, event, helper);

    },

    changeTipoConta: function (component, event, helper) {
        component.set ("v.accountType", event.getParam("value"));
        helper.getAccountHelper(component, event, helper);
        console.log(component.get("v.accountType"));
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'adicionar':
                component.set("v.pacote", true);
                break;
            case 'deletar':
                helper.removeBook(component, row);
                break;
        }
    },

    abrirModal: function (component, event, helper) {
        component.set("v.exibirModal", true);
    },

    fecharModal: function (component, event, helper) {
        component.set("v.exibirModal", false);
    },

    fecharModal1: function (component, event, helper) {
        component.set("v.pacote", false);
    },

    handleSuccess: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },

    buscaCep: function (component, event, helper) {
        helper.getCepHelper(component, event, helper);
    },

    changeCep: function (component, event, helper) {
        component.set ("v.cep", event.getParam("value"));
    },

    novaConta: function (component, event, helper) {
        
        helper.salvardados(component, event, helper);
    },

})