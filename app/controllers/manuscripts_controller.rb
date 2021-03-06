class ManuscriptsController < DefaultNamespaceController
    
    # BEFORE ACTIONS
    
    before_action :signed_in_user, :only => [ :create, :new ]
    before_action :correct_user, :only => [ :contents, :destroy, :edit, :show, :update, :write ]
    
    # display the table of contents. AJAX and jQuery are used to make it
    # interactive.
    def contents
        @manuscript = Manuscript.find( params[ :id ] )
        @sections = @manuscript.sections.all
        @section = @manuscript.sections.build
        
        render( { :layout => 'manuscript_overview.html.haml' } )
    end
    
    # create a manuscript and its inkling.
    def create
        @manuscript = current_user.manuscripts.build( manuscript_params )
        # assign the attributes that the user does not need to specify.
        @manuscript.assign_attributes( :word_count => 0 )
        
        if @manuscript.save
            redirect_to manuscript_path( @manuscript )
        else
            render 'new'
        end
    end
    
    # destroy a manuscript.
    def destroy
        manuscript = Manuscript.find( params[ :id ] )
        manuscript.destroy
        
        redirect_to user_path( current_user.id )
    end
    
    # display the edit page, where manuscript settings can be updated.
    def edit
        @manuscript = Manuscript.find( params[ :id ] )
        @inkling = @manuscript.inkling
        
        render( { :layout => 'manuscript_overview.html.haml' } )
    end
    
    # display the feedback page, where all of the feedback for the manuscript is
    # shown.
    def feedback
        @manuscript = Manuscript.find( params[ :id ] )
        @feedback = @manuscript.feedback.paginate( :page => params[ :page ] )
    end

    # display the manuscript library.
    def index
        @updated_manuscripts = Manuscript.limit( 100 ).order( :created_at => :asc ).paginate( :page => params[ :page ] )
    end

    # display the new manuscript page.
    def new
        @manuscript = current_user.manuscripts.build
        @manuscript.build_inkling
    end
    
    # display the manuscript contents in a format for reading.
    def read
        @manuscript = Manuscript.find( params[ :id ] )
        @open_section = params[ :section_id ].nil? ? @manuscript.sections.first : Section.find( params[ :section_id ] )
        @sections = @manuscript.sections.all
        @feedback = Feedback.new
    end

    # display information/statistics relating to the manuscript.
    def show
        @manuscript = Manuscript.find( params[ :id ] )
        @inkling = @manuscript.inkling
        
        render( { :layout => 'manuscript_overview.html.haml' } )
    end 
    
    # update manuscript and inkling settings.
    def update
        @manuscript = Manuscript.find( params[ :id ] )
        
        if @manuscript.update_attributes( manuscript_params )
            redirect_to manuscript_url( @manuscript )
            flash[ :success ] = 'Manuscript settings have been successfully updated.'
        else
            render 'edit'
        end
    end
    
    # display the manuscript contents in a format for writing.
    def write
        @manuscript = Manuscript.find( params[ :id ] )
        @open_section = params[ :section_id ].nil? ? @manuscript.sections.first : Section.find( params[ :section_id ] )
        @sections = @manuscript.sections.all
        
        render( { :layout => 'manuscript_overview.html.haml' } )
    end
    
    private
    
        def correct_user
            @manuscript = Manuscript.find( params[ :id ] )
            @user = @manuscript.user
            redirect_to( root_path ) unless current_user?( @user )
        end
    
        def manuscript_params
            params.require( :manuscript ).permit( :description, :rating_id, :title, :user_id, :inkling_attributes => [ :hardcore, :revival_fee, :revival_fee_currency, :word_count_goal, :word_rate_goal, :word_rate_goal_basis ], :genre_ids => [  ] )
        end
end
