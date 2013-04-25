require "kaseyaws/version"
require "kaseyaws/security"
require "savon"

module KaseyaWS

  class Client
    HASH_ALGORITHM = "SHA-256"

    def initialize (username,password,hostname)

      # The FQDN of the Kaseya web service
      @serviceurl = "https://" + hostname + "/vsaWS/kaseyaWS.asmx?WSDL"
      # Get the clients IP address
      @client_ip = KaseyaWS::Security.client_ip
      # Hash savon option for reuse
      @savon_options={
        wsdl: @serviceurl,
        convert_request_keys_to: :camelcase,
        env_namespace: :soap,
        open_timeout: 30,
        log: true
      }
      # Autheticate with web service and get session id
      @sessionid = self.authenticate(username,password)

    end

    def authenticate(username,password)

      random_number = KaseyaWS::Security.secure_random(8)
      covered_password = KaseyaWS::Security.compute_covered_password(username,password, random_number, HASH_ALGORITHM)
      browser_ip = @client_ip

      client = Savon.client(@savon_options)

      response = client.call(:authenticate, message: {req:[{
                                                             user_name: username,
                                                             covered_password: covered_password,
                                                             random_number: random_number,
                                                             browser_ip: browser_ip,
                             hashing_algorithm: HASH_ALGORITHM}]}
                             )
      @sessionid = response.body[:authenticate_response][:authenticate_result][:session_id]

    end

    def get_alarm (monitor_alarm_id)

      client = Savon.client(@savon_options)

      response = client.call(:get_alarm, message: {req:[{
                                                          monitor_alarm_i_d: monitor_alarm_id,
                                                          browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_alarm_response][:get_alarm_result]
    end

    def get_alarm_list (get_all_records)

      client = Savon.client(@savon_options)

      response = client.call(:get_alarm_list, message: {req:[{
                                                               return_all_records: get_all_records,
                                                               browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_alarm_list_response][:get_alarm_list_result]
    end

    def get_machine(machine_group_id)

      client = Savon.client(@savon_options)

      response = client.call(:get_machine, message: {req:[{
                                                            machine___group_i_d: machine_group_id,
                                                            browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_machine_response][:get_machine_result]
    end

    def get_machine_group_list

      client = Savon.client(@savon_options)

      response = client.call(:get_machine_group_list, message: {req:[{
                                                                       browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_machine_group_list_response][:get_machine_group_list_result]
    end

    def get_machine_list(machine_group,machine_collection)

      client = Savon.client(@savon_options)

      response = client.call(:get_machine_list, message: {req:[{
                                                                 machine_group: machine_group,
                                                                 machine_collection: machine_collection,
                                                                 browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_machine_list_response][:get_machine_list_result]
    end

  end
end
