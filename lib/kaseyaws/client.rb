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

  # The client class is just a wrapper for the Kaseya VSA WSDL. All methods return a Hash object

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

      response = self.client.call(:add_mach_group_to_scope, :message => {:req =>[{
                                                                                   :group_name => group_name,
                                                                                   :scope_name => scope_name,
                                                                                   :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:add_mach_group_to_scope_response][:add_mach_group_to_scope_result]
    end



    def add_org_to_scope(company_id,scope_id)

      response = self.client.call(:add_org_to_scope, :message => {:req =>[{
                                                                            :company_i_d => company_id,
                                                                            :scope_i_d => scope_id,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:add_org_to_scope_response][:add_org_to_scope_result]
    end

    def add_user_to_role(username,role_id)

      response = self.client.call(:add_user_to_role, :message => {:req =>[{
                                                                            :user_name => user_name,
                                                                            :role_i_d => role_id,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:add_user_to_role_response][:add_user_to_role_result]
    end

    def authenticate(username,password)

      random_number = KaseyaWS::Security.secure_random
      covered_password = KaseyaWS::Security.compute_covered_password(username,password, random_number, HASH_ALGORITHM)

      self.client = Savon::Client.new(@savon_options)

      response = self.client.call(:authenticate, :message => {:req =>[{
                                                                        :user_name => username,
                                                                        :covered_password => covered_password,
                                                                        :random_number => random_number,
                                                                        :browser_i_p => @client_ip,
                                  :hashing_algorithm => HASH_ALGORITHM}]}
                                  )
      @sessionid = response.body[:authenticate_response][:authenticate_result][:session_id]
    end

    def close_alarm (monitor_alarm_id, notes)

      response = self.client.call(:close_alarm, :message => {:req =>[{
                                                                       :monitor_alarm_i_d => monitor_alarm_id,
                                                                       :notes => notes,
                                                                       :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:close_alarm_response][:close_alarm_result]
    end

    def create_machine_group (group_name,org_name,parent_name)

      response = self.client.call(:create_machine_group, :message => {:req =>[{
                                                                                :group_name => group_name,
                                                                                :org_name => org_name,
                                                                                :parent_name => parent_name,
                                                                                :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:create_machine_group_response][:create_machine_group_result]
    end

    def create_role (role_name,role_type,parent_role_name)

      response = self.client.call(:create_role, :message => {:req =>[{
                                                                       :role_name => role_name,
                                                                       :role_type => role_type,
                                                                       :parent_role_name => parent_role_name,
                                                                       :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:create_role_response][:create_role_result]
    end

    def delete_admin (user_name)

      response = self.client.call(:delete_admin, :message => {:req =>[{
                                                                        :user_name => user_name,
                                                                        :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:delete_admin_response][:delete_admin_result]
    end


    def delete_agent (agent_guid, uninstall_agent_first)

      response = self.client.call(:delete_agent, :message => {:req =>[{
                                                                        :agent_guid => agent_guid,
                                                                        :uninstall_agent_first => uninstall_agent_first,
                                                                        :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:delete_agent_response][:delete_agent_result]
    end

    def delete_agent_install_package (package_id)

      response = self.client.call(:delete_agent_install_package, :message => {:req =>[{
                                                                                        :package_id => package_id,
                                                                                        :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:delete_agent_install_package_response][:delete_agent_install_package_result]
    end

    def delete_machine_group (group_name)

      response = self.client.call(:delete_machine_group, :message => {:req =>[{
                                                                                :group_name => group_name,
                                                                                :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:delete_machine_group_response][:delete_machine_group_result]
    end

    def echo (input)

      response = self.client.call(:echo, :message => { :input => input })

      response.body[:echo_response][:echo_result]
    end

    def echo_mt (payload)

      response = self.client.call(:echo_mt, :message => {:req =>[{
                                                                   :payload => payload,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:echo_mt_response][:echo_mt_result]
    end

    def get_alarm (monitor_alarm_id)

      response = self.client.call(:get_alarm, :message => {:req =>[{
                                                                     :monitor_alarm_i_d => monitor_alarm_id,
                                                                     :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_alarm_response][:get_alarm_result]
    end

    def get_alarm_list (get_all_records=true)

      response = self.client.call(:get_alarm_list, :message => {:req =>[{
                                                                          :return_all_records => get_all_records,
                                                                          :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_alarm_list_response][:get_alarm_list_result]
    end

    def get_machine(machine_group_id)

      response = self.client.call(:get_machine, :message => {:req =>[{
                                                                       :machine___group_i_d => machine_group_id,
                                                                       :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_machine_response][:get_machine_result]
    end

    def get_machine_group_list

      response = self.client.call(:get_machine_group_list, :message => {:req =>[{
                                                                                  :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_machine_group_list_response][:get_machine_group_list_result]
    end

    def get_machine_list(machine_group,machine_collection)

      response = self.client.call(:get_machine_list, :message => {:req =>[{
                                                                            :machine_group => machine_group,
                                                                            :machine_collection => machine_collection,
                                                                            :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_machine_list_response][:get_machine_list_result]
    end

    def get_notes_list(added_since)

      response = self.client.call(:get_notes_list, :message => {:req =>[{
                                                                          :added_since => get_notes_list,
                                                                          :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_notes_list_response][:get_notes_list_result]
    end

    def get_orgs

      response = self.client.call(:get_orgs, :message => {:req =>[{
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_orgs_response][:get_orgs_result]
    end

    def get_org_types

      response = self.client.call(:get_org_types, :message => {:req =>[{
                                                                         :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_org_types_response][:get_org_types_result]
    end

    def get_orgs_by_scope_id (scope_id)

      response = self.client.call(:get_orgs_by_scope_id, :message => {:req =>[{
                                                                                :scope_i_d => scope_id,
                                                                                :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_orgs_by_scope_id_response][:get_orgs_by_scope_id_result]
    end

    def get_package_urls (group_name)

      response = self.client.call(:get_package_urls, :message => {:req =>[{
                                                                            :group_name => group_name,
                                                                            :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_package_urls_response][:get_package_urls_result]
    end

    def get_partner_user_location (admin_id)

      response = self.client.call(:get_partner_user_location, :message => {:req =>[{
                                                                                     :admin_id => admin_id,
                                                                                     :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_partner_user_location_response][:get_partner_user_location_result]
    end

    def get_published_view_columns (view_name)

      response = self.client.call(:get_published_view_columns, :message => {:req =>[{
                                                                                      :view_name => view_name,
                                                                                      :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_published_view_columns_response][:get_published_view_columns_result]
    end

    def get_published_views

      response = self.client.call(:get_published_views, :message => {:req =>[{
                                                                               :browser_i_p => @client_ip,
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_published_views_response][:get_published_views_result]
    end

    def get_roles

      response = self.client.call(:get_roles, :message => {:req =>[{
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_roles_response][:get_roles_result]
    end

    def get_scopes

      response = self.client.call(:get_scopes, :message => {:req =>[{
                                  :session_i_d => @sessionid}]}
                                  )
      response.body[:get_scopes_response][:get_scopes_result]
    end

    

  end
end
