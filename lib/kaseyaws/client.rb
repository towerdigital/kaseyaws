#!/usr/bin/env ruby
#
# Copyright 2013 by Phillip Henslee (phenslee@towerdigital.us).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#

# Provides a simple client for the Kaseya VSA web service.

require "savon"

module KaseyaWS

  class Client
    HASH_ALGORITHM = "SHA-256"
    attr_accessor :client

    def initialize (username,password,hostname)

      @vsa_serviceurl = "https://" + hostname + "/vsaWS/kaseyaWS.asmx?WSDL"
      @client_ip = KaseyaWS::Security.client_ip
      @savon_options={
        wsdl: @vsa_serviceurl,
        convert_request_keys_to: :camelcase,
        env_namespace: :soap,
        open_timeout: 30,
        log: false
      }
      @sessionid = self.authenticate(username,password)

    end

    def add_mach_group_to_scope(group_name,scope_name)

      response = self.client.call(:add_mach_group_to_scope, message: {req:[{
                                                                        group_name: group_name,
                                                                        scope_name: scope_name,
                                                                        browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:add_mach_group_to_scope_response][:add_mach_group_to_scope_result]
    end

    def add_org_to_scope(company_id,scope_id)

      response = self.client.call(:add_org_to_scope, message: {req:[{
                                                                 company_i_d: company_id,
                                                                 scope_i_d: scope_id,
                             session_i_d: @sessionid}]}
                             )
      response.body[:add_org_to_scope_response][:add_org_to_scope_result]
    end

    def add_user_to_role(username,role_id)

      response = self.client.call(:add_user_to_role, message: {req:[{
                                                                 user_name: user_name,
                                                                 role_i_d: role_id,
                             session_i_d: @sessionid}]}
                             )
      response.body[:add_user_to_role_response][:add_user_to_role_result]
    end

    def authenticate(username,password)

      random_number = KaseyaWS::Security.secure_random
      covered_password = KaseyaWS::Security.compute_covered_password(username,password, random_number, HASH_ALGORITHM)
      browser_ip = @client_ip

      self.client = Savon::Client.new(@savon_options)

      response = self.client.call(:authenticate, message: {req:[{
                                                                  user_name: username,
                                                                  covered_password: covered_password,
                                                                  random_number: random_number,
                                                                  browser_ip: browser_ip,
                                  hashing_algorithm: HASH_ALGORITHM}]}
                                  )
      @sessionid = response.body[:authenticate_response][:authenticate_result][:session_id]
    end

    def close_alarm (monitor_alarm_id, notes)

      response = self.client.call(:close_alarm, message: {req:[{
                                                            monitor_alarm_i_d: monitor_alarm_id,
                                                            notes: notes,
                                                            browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:close_alarm_response][:close_alarm_result]
    end

    def create_role (role_name,role_type,parent_role_name)

      response = self.client.call(:create_role, message: {req:[{
                                                            role_name: role_name,
                                                            role_type: role_type,
                                                            parent_role_name: parent_role_name,
                                                            browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:create_role_response][:create_role_result]
    end

    def create_role (role_name,role_type,parent_role_name)

      response = self.client.call(:create_role, message: {req:[{
                                                            role_name: role_name,
                                                            role_type: role_type,
                                                            parent_role_name: parent_role_name,
                                                            browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:create_role_response][:create_role_result]
    end

    def delete_admin (user_name)

      response = self.client.call(:delete_admin, message: {req:[{
                                                            user_name: user_name,
                                                            browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:delete_admin_response][:delete_admin_result]
    end

    def get_alarm (monitor_alarm_id)

      response = self.client.call(:get_alarm, message: {req:[{
                                                               monitor_alarm_i_d: monitor_alarm_id,
                                                               browser_ip: @client_ip,
                                  session_i_d: @sessionid}]}
                                  )
      response.body[:get_alarm_response][:get_alarm_result]
    end

    def get_alarm_list (get_all_records=true)

      response = self.client.call(:get_alarm_list, message: {req:[{
                                                                    return_all_records: get_all_records,
                                                                    browser_ip: @client_ip,
                                  session_i_d: @sessionid}]}
                                  )
      response.body[:get_alarm_list_response][:get_alarm_list_result]
    end

    def get_machine(machine_group_id)

      response = self.client.call(:get_machine, message: {req:[{
                                                            machine___group_i_d: machine_group_id,
                                                            browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_machine_response][:get_machine_result]
    end

    def get_machine_group_list

      response = self.client.call(:get_machine_group_list, message: {req:[{
                                                                       browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_machine_group_list_response][:get_machine_group_list_result]
    end

    def get_machine_list(machine_group,machine_collection)

      response = self.client.call(:get_machine_list, message: {req:[{
                                                                 machine_group: machine_group,
                                                                 machine_collection: machine_collection,
                                                                 browser_ip: @client_ip,
                             session_i_d: @sessionid}]}
                             )
      response.body[:get_machine_list_response][:get_machine_list_result]
    end

  end
end