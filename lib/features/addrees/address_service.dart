import 'package:flutter/material.dart';
import 'package:sweet_store/core/network/api_client.dart';

class AddressService {

  static final api = ApiClient();
  // 🔥 Agora guarda uma LISTA de endereços
  static final ValueNotifier<List<Map<String, dynamic>>> addresses = ValueNotifier([]);

  static Future<void> fetchAddresses() async {
    try {
      // Faz a requisição GET para o endpoint de endereços
      final response = await api.get("/endereco");

      // O seu ApiClient já trata erros e retorna o body decodificado
      // A estrutura do seu Java coloca os dados na chave "data"
      if (response != null && response["data"] != null) {
        final List<dynamic> listaBruta = response["data"];

        // Converte a lista dinâmica para o formato esperado e atualiza o ValueNotifier
        addresses.value = listaBruta.cast<Map<String, dynamic>>();
        print("Endereços carregados: ${addresses.value}");
      }
    } catch (e) {
      print("Erro ao carregar endereços: $e");
    }
  }

  // address_service.dart

  static Future<bool> save(Map<String, dynamic> dados) async {
    try {
      // 🚀 Envia os dados para o endpoint /endereco
      final response = await api.post("/endereco", dados);

      // Se o ApiClient não lançou exceção, a operação foi um sucesso
      // O backend retorna o objeto criado dentro da chave "data"
      if (response != null && response["data"] != null) {
        // Opcional: Recarregar a lista local após salvar
        await fetchAddresses();
        return true;
      }
      return false;
    } catch (e) {
      print("Erro ao salvar endereço na API: $e");
      return false;
    }
  }

  static void updateAddress(String id, Map<String, dynamic> updatedAddress) {
    if (updatedAddress['padrao'] == true) {
      _removerPadraoAtual();
    }

    final newList = addresses.value.map((e) {
      if (e['id'] == id) return updatedAddress;
      return e;
    }).toList();

    addresses.value = newList;
  }

  static void removeAddress(String id) {
    addresses.value = addresses.value.where((e) => e['id'] != id).toList();
  }

  static void setAsDefault(String id) {
    final newList = addresses.value.map((e) {
      return {...e, 'padrao': e['id'] == id}; // Só fica true se for o id escolhido
    }).toList();

    addresses.value = newList;
  }

  static void _removerPadraoAtual() {
    // Tira o "padrao = true" do endereço que estava marcado
    addresses.value = addresses.value.map((e) => {...e, 'padrao': false}).toList();
  }


  static bool hasAddress() {
    return addresses.value != null;
  }
}