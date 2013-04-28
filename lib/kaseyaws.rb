#!/usr/bin/env ruby
#
# Copyright 2013 by Phillip Henslee (ph2@ph2.us).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#

# Provides a simple client for the Kaseya VSA web service.

require "kaseyaws/version"
require "kaseyaws/security"
require "savon"

module KaseyaWS

  class Client
    HASH_ALGORITHM = "SHA-256"

    def initialize (username,password,hostname)

      @vsa_serviceurl = "https://" + hostname + "/vsaWS/kaseyaWS.asmx?WSDL"
      @client_ip = KaseyaWS::Security.client_ip
      @savon_options={
        wsdl: @vsa_serviceurl,
        convert_request_keys_to: :camelcase,
        env_namespace: :soap,
        open_timeout: 30,
        log: true
      }
      @sessionid = self.authenticate(username,password)

    end

    # def add_org(org_ref, org_name, default_dept_name, default_mg_name, website, no_emps, ann_revenue,
    #             method_of_contact, org_parent_ref, addr1, city, state, postal_code, country_ref, org_type
    #             primary_email, primary_phone, primary_fax, primary_staff_fk, browser_ip, sesion_id)

    #   client = Savon.client(@savon_options)

    #   response = client.call(:add_org, message: {req:[{
    #                                                                     group_name: group_name,
    #                                                                     scope_name: scope_name,
    #                                                                     browser_ip: @client_ip,
    #                          session_i_d: @sessionid}]}
    #                          )
    #   response.body[:get_machine_list_response][:get_machine_list_result]
    # end

    def add_mach_group_to_scope(group_name,scope_name)

      client = Savon.client(@savon_options)

      response = client.call(:add_mach_group_to_scope, message: {req:[{
                                                                        group_name: group_name,
                                                                        scope_name: scope_name,
                                                                        browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_machine_list_response][:get_machine_list_result]
    end

    def authenticate(username,password)

      random_number = KaseyaWS::Security.secure_random
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

    def get_alarm_list (get_all_records=true)

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
